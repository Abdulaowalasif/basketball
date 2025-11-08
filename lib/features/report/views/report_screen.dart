import 'dart:io';

import 'package:basketball/features/report/model/coach_report_model.dart';
import 'package:basketball/features/report/model/player_report_model.dart';
import 'package:basketball/features/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../../core/constants/api_endpoin.dart';
import '../widgets/StatBar.dart';
import '../widgets/section.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  String toBulletPoints(List<String> items) {
    return items.map((e) => '• $e').join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final storage = Get.put(StorageService());
    bool isPlayer = storage.read('is_player');

    final dynamic report = isPlayer
        ? Get.arguments as PlayerReportModel
        : Get.arguments as CoachReportModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          report.reportTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Section(title: 'Overview', content: report.overview),
            Section(
              title: 'Strength',
              content: toBulletPoints(report.strengths),
            ),
            Section(
              title: 'Weaknesses',
              content: toBulletPoints(report.weaknesses),
            ),
            if (report.projection == null || report.projection.isEmpty)
              const SizedBox.shrink()
            else
              Section(title: 'Projection', content: report.projection),
            const SizedBox(height: 16),
            isPlayer
                ? Text(
              'Points Per Game (PPG)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
                : const SizedBox.shrink(),
            const SizedBox(height: 16),
            isPlayer
                ? StatBar(
              title: 'Field Goal % (${report.fieldGoalPercentage}%)',
              value: (double.tryParse(
                  report.fieldGoalPercentage.toString()) ??
                  0) /
                  100,
            )
                : const SizedBox.shrink(),
            isPlayer
                ? StatBar(
              title: 'Rebounds (${report.rebounds})',
              value:
              (double.tryParse(report.rebounds.toString()) ?? 0) / 100,
            )
                : const SizedBox.shrink(),
            isPlayer
                ? StatBar(
              title: 'Assists (${report.assists})',
              value:
              (double.tryParse(report.assists.toString()) ?? 0) / 100,
            )
                : const SizedBox.shrink(),
            isPlayer
                ? StatBar(
              title: 'Steals & Blocks (${report.stealsAndBlocks})',
              value: (double.tryParse(
                  report.stealsAndBlocks.toString()) ??
                  0) /
                  100,
            )
                : const SizedBox.shrink(),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () => _handleDownload(context, report, isPlayer),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.download, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Download Report',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDownload(
      BuildContext context,
      dynamic report,
      bool isPlayer,
      ) async {
    // Show loading indicator
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    try {
      final reportId = report.id?.toString() ?? '';
      if (reportId.isEmpty) {
        Get.back(); // Close loading dialog
        _showErrorSnackbar('Report ID is missing');
        return;
      }

      // Dynamic endpoint based on user type
      String userType = isPlayer ? 'player' : 'coach';

      String downloadUrl;
      if (isPlayer) {
        downloadUrl = '${ApiEndpoints.playerReportPdf}$reportId';
      } else {
        downloadUrl = '${ApiEndpoints.coachReportPdf}$reportId';
      }

      final endpoint = downloadUrl;
      final fileName = 'report_$reportId.pdf';

      print('Downloading report: $endpoint');
      print('User type: $userType');
      print('Report ID: $reportId');
      print('File name: $fileName');

      // Request storage permission with improved handling
      PermissionStatus permission = await _requestPermissionWithRetry();

      if (permission != PermissionStatus.granted) {
        Get.back(); // Close loading dialog
        _showErrorSnackbar('Storage permission is required to download files');
        return;
      }

      // Make the download request
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          // Add any required headers like authorization token
          // 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 60));

      print('Download response status: ${response.statusCode}');
      print('Download response headers: ${response.headers}');

      if (response.statusCode == 200) {
        // Get the appropriate directory
        Directory? dir = await _getDownloadDirectory();

        if (dir == null) {
          Get.back(); // Close loading dialog
          _showErrorSnackbar('Could not access download directory');
          return;
        }

        // Create the file
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        Get.back(); // Close loading dialog

        if (context.mounted) {
          Get.snackbar(
            'Download Complete',
            'File saved to ${file.path}',
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
            duration: const Duration(seconds: 5),
          );
        }
      } else {
        Get.back(); // Close loading dialog
        print('Download failed: ${response.statusCode} - ${response.body}');
        _showErrorSnackbar('Download failed. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      print('Download error: $e');
      _showErrorSnackbar('Download failed: $e');
    }
  }

  Future<PermissionStatus> _requestPermissionWithRetry() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      print('Android version: $androidVersion');

      // Determine which permission to request based on Android version
      Permission targetPermission;
      if (androidVersion >= 33) {
        // Android 13+ - Try manage external storage first
        targetPermission = Permission.manageExternalStorage;
      } else if (androidVersion >= 30) {
        // Android 11-12 - Try manage external storage first
        targetPermission = Permission.manageExternalStorage;
      } else {
        // Android 10 and below - Use regular storage permission
        targetPermission = Permission.storage;
      }

      // Check current permission status
      PermissionStatus currentStatus = await targetPermission.status;
      print('Current permission status: $currentStatus');

      // If already granted, return immediately
      if (currentStatus == PermissionStatus.granted) {
        return PermissionStatus.granted;
      }

      // If permanently denied, try alternative approach
      if (currentStatus == PermissionStatus.permanentlyDenied) {
        print('Permission permanently denied, trying alternative permission');

        if (androidVersion >= 30 && targetPermission == Permission.manageExternalStorage) {
          // Fallback to regular storage permission
          final fallbackPermission = await Permission.storage.request();
          if (fallbackPermission == PermissionStatus.granted) {
            return PermissionStatus.granted;
          }
        }

        // For permanently denied, we'll use app-specific storage
        print('Using app-specific storage due to permanently denied permission');
        return PermissionStatus.granted; // We can always use app-specific storage
      }

      // Request permission with user-friendly dialog
      bool shouldRequest = true;

      if (currentStatus == PermissionStatus.denied) {
        // Show explanation dialog before requesting permission
        shouldRequest = await _showPermissionExplanationDialog() ?? false;
      }

      if (!shouldRequest) {
        return PermissionStatus.denied;
      }

      // Request the permission
      PermissionStatus requestResult = await targetPermission.request();
      print('Permission request result: $requestResult');

      // If main permission failed but we're on Android 11+, try fallback
      if (requestResult != PermissionStatus.granted &&
          androidVersion >= 30 &&
          targetPermission == Permission.manageExternalStorage) {

        print('Main permission failed, trying storage permission as fallback');
        final fallbackResult = await Permission.storage.request();
        if (fallbackResult == PermissionStatus.granted) {
          return PermissionStatus.granted;
        }
      }

      // If still no permission, we can use app-specific storage
      if (requestResult != PermissionStatus.granted) {
        print('No external storage permission, using app-specific storage');
        return PermissionStatus.granted; // App-specific storage doesn't need permission
      }

      return requestResult;
    } else {
      // iOS doesn't need storage permission for app documents
      return PermissionStatus.granted;
    }
  }

  Future<bool?> _showPermissionExplanationDialog() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Storage Permission Needed'),
        content: const Text(
            'This app needs storage permission to save your downloaded reports to your device. '
                'This allows you to access your files from other apps and keep them even if you uninstall this app.\n\n'
                'Would you like to grant this permission?'
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Not Now'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  Future<Directory?> _getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        final androidVersion = await _getAndroidVersion();
        print('Android version: $androidVersion');

        // Always try to use the default Downloads folder first
        final defaultDownloadsDir = Directory('/storage/emulated/0/Download');

        try {
          if (await defaultDownloadsDir.exists()) {
            // Test if we can write to the default Downloads folder
            final testFile = File('${defaultDownloadsDir.path}/.test_write_${DateTime.now().millisecondsSinceEpoch}');
            await testFile.writeAsString('test');
            await testFile.delete();
            print('Using default Downloads directory: ${defaultDownloadsDir.path}');
            return defaultDownloadsDir;
          }
        } catch (e) {
          print('Cannot write to default Downloads folder: $e');
        }

        // If default Downloads doesn't work, try external storage Downloads
        try {
          Directory? externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            // Create Downloads subfolder in external storage
            final externalDownloadsDir = Directory('${externalDir.path}/Downloads');
            if (!await externalDownloadsDir.exists()) {
              await externalDownloadsDir.create(recursive: true);
            }
            print('Using external storage Downloads: ${externalDownloadsDir.path}');
            return externalDownloadsDir;
          }
        } catch (e) {
          print('Cannot use external storage Downloads: $e');
        }

        // Final fallback - app documents directory
        try {
          final appDocsDir = await getApplicationDocumentsDirectory();
          final appDownloadsDir = Directory('${appDocsDir.path}/Downloads');
          if (!await appDownloadsDir.exists()) {
            await appDownloadsDir.create(recursive: true);
          }
          print('Using app Documents Downloads folder: ${appDownloadsDir.path}');
          return appDownloadsDir;
        } catch (e) {
          print('Cannot create app Downloads directory: $e');
        }
      } else {
        // iOS - use documents directory Downloads subfolder
        try {
          final appDocsDir = await getApplicationDocumentsDirectory();
          final iosDownloadsDir = Directory('${appDocsDir.path}/Downloads');
          if (!await iosDownloadsDir.exists()) {
            await iosDownloadsDir.create(recursive: true);
          }
          print('Using iOS Documents Downloads folder: ${iosDownloadsDir.path}');
          return iosDownloadsDir;
        } catch (e) {
          print('Cannot create iOS Downloads directory: $e');
        }
      }

      // Last resort - return app documents directory
      print('Using app documents as last resort');
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      print('Error in _getDownloadDirectory: $e');
      try {
        return await getApplicationDocumentsDirectory();
      } catch (e2) {
        print('Critical error - cannot get any directory: $e2');
        return null;
      }
    }
  }

  Future<int> _getAndroidVersion() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.sdkInt;
      }
      return 30; // Default fallback
    } catch (e) {
      print('Error getting Android version: $e');
      return 30; // Default fallback
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
      duration: const Duration(seconds: 5),
    );
  }
}