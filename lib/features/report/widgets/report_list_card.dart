import 'dart:io';
import 'package:basketball/core/constants/api_endpoin.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../storage/storage_service.dart';

class ReportListCard extends StatelessWidget {
  final List reports;
  final int index;
  final VoidCallback onPressed;

  ReportListCard({
    Key? key,
    required this.reports,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (index >= reports.length || reports[index] == null) {
      print('Invalid report index or null report');
      return const SizedBox();
    }

    final report = reports[index];
    final reportId = report.id?.toString() ?? '';
    final bool isPlayer = Get.put(StorageService()).read('is_player') ?? false;
    String reportDownloadUrl;
    String reportEmailUrl;
    if (isPlayer) {
      reportDownloadUrl = '${ApiEndpoints.playerReportPdf}$reportId';
      reportEmailUrl = '${ApiEndpoints.playerSendReportMail}$reportId';
    } else {
      reportDownloadUrl = '${ApiEndpoints.coachReportPdf}$reportId';
      reportEmailUrl = '${ApiEndpoints.coachSendReportMail}$reportId';
    }

    if (reportId.isEmpty) {
      print('Report ID is null or empty for report at index $index');
      return const SizedBox();
    }

    print('Report ID: $reportId');

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.reportTitle ?? 'Untitled Report',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${report.createAt ?? 'Unknown'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _iconBtn(
                  false,
                  context,
                  'assets/icons/download.png',
                  reportDownloadUrl,
                  isDownload: true,
                  fileName: 'report_$reportId.pdf',
                  reportId: reportId,
                ),
                _iconBtn(
                  true,
                  context,
                  'assets/icons/emailshare.png',
                  reportEmailUrl,
                  reportId: reportId,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(
      bool isShare,
      BuildContext context,
      String imagePath,
      String endpoint, {
        bool isDownload = false,
        String? fileName,
        required String reportId,
      }) {
    print('Endpoint: $endpoint');
    print('Report ID in _iconBtn: $reportId');

    return GestureDetector(
      onTap: () async {
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
        );

        try {
          if (isShare) {
            await _handleShare(endpoint, reportId);
          } else if (isDownload && fileName != null) {
            await _handleDownload(context, endpoint, fileName, reportId);
          }
        } catch (e) {
          print('Error in _iconBtn: $e');
          Get.back();
          _showErrorSnackbar('An error occurred: $e');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: Image.asset(
          imagePath,
          height: 16,
          width: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> _handleShare(String endpoint, String reportId) async {
    try {
      print('Sharing report: $endpoint');
      print('Report ID for sharing: $reportId');

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      Get.back();

      print('Share response status: ${response.statusCode}');
      print('Share response body: ${response.body}');

      if (response.statusCode == 200) {
        Get.snackbar(
          'Share Report',
          'Report shared successfully via email',
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 3),
        );
      } else {
        _showErrorSnackbar('Failed to share report. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.back();
      print('Share error: $e');
      _showErrorSnackbar('Failed to share report: $e');
    }
  }

  Future<void> _handleDownload(
      BuildContext context,
      String endpoint,
      String fileName,
      String reportId,
      ) async {
    try {
      print('Downloading report: $endpoint');
      print('Report ID for download: $reportId');
      print('File name: $fileName');

      await _requestPermissionWithRetry();

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 60));

      print('Download response status: ${response.statusCode}');
      print('Download response headers: ${response.headers}');

      if (response.statusCode == 200) {
        Directory? dir = await _getDownloadDirectory();

        if (dir == null) {
          Get.back();
          _showErrorSnackbar('Could not access any download directory');
          return;
        }

        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        String finalFileName = fileName;
        File file = File('${dir.path}/$finalFileName');
        int counter = 1;

        while (await file.exists()) {
          final nameWithoutExtension = fileName.replaceAll('.pdf', '');
          finalFileName = '${nameWithoutExtension}_($counter).pdf';
          file = File('${dir.path}/$finalFileName');
          counter++;
        }

        await file.writeAsBytes(response.bodyBytes);
        print('File saved successfully to: ${file.path}');

        Get.back();

        if (context.mounted) {
          String displayPath = _getUserFriendlyPath(file.path);

          Get.snackbar(
            'Download Complete',
            'File saved to $displayPath',
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
            duration: const Duration(seconds: 5),
            messageText: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'File saved successfully!',
                  style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Location: $displayPath',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'File: $finalFileName',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        Get.back();
        print('Download failed: ${response.statusCode} - ${response.body}');
        _showErrorSnackbar('Download failed. Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      Get.back();
      print('Download error: $e');
      String errorMessage = 'Download failed';
      if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Download timeout. Please check your internet connection and try again.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Invalid server response. Please try again.';
      } else {
        errorMessage = 'Download failed: ${e.toString()}';
      }
      _showErrorSnackbar(errorMessage);
    }
  }

  String _getUserFriendlyPath(String fullPath) {
    if (fullPath.contains('/storage/emulated/0/Download')) {
      return 'Downloads folder';
    } else if (fullPath.contains('/Android/data/')) {
      return 'App Downloads folder';
    } else if (fullPath.contains('app_flutter/Documents')) {
      return 'App Documents folder';
    } else {
      final pathParts = fullPath.split('/');
      if (pathParts.length >= 2) {
        return '.../${pathParts[pathParts.length - 2]}/${pathParts[pathParts.length - 1]}';
      }
      return fullPath;
    }
  }

  Future<PermissionStatus> _requestPermissionWithRetry() async {
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      print('Android version: $androidVersion');

      Permission targetPermission;
      if (androidVersion >= 33) {
        targetPermission = Permission.manageExternalStorage;
      } else if (androidVersion >= 30) {
        targetPermission = Permission.manageExternalStorage;
      } else {
        targetPermission = Permission.storage;
      }

      PermissionStatus currentStatus = await targetPermission.status;
      print('Current permission status: $currentStatus');

      if (currentStatus == PermissionStatus.granted) {
        return PermissionStatus.granted;
      }

      if (currentStatus == PermissionStatus.permanentlyDenied) {
        print('Permission permanently denied, trying alternative permission');
        if (androidVersion >= 30 && targetPermission == Permission.manageExternalStorage) {
          final fallbackPermission = await Permission.storage.request();
          if (fallbackPermission == PermissionStatus.granted) {
            return PermissionStatus.granted;
          }
        }
        print('Using app-specific storage due to permanently denied permission');
        return PermissionStatus.granted;
      }

      bool shouldRequest = true;
      if (currentStatus == PermissionStatus.denied) {
        shouldRequest = await _showPermissionExplanationDialog() ?? false;
      }

      if (!shouldRequest) {
        return PermissionStatus.denied;
      }

      PermissionStatus requestResult = await targetPermission.request();
      print('Permission request result: $requestResult');

      if (requestResult != PermissionStatus.granted &&
          androidVersion >= 30 &&
          targetPermission == Permission.manageExternalStorage) {
        print('Main permission failed, trying storage permission as fallback');
        final fallbackResult = await Permission.storage.request();
        if (fallbackResult == PermissionStatus.granted) {
          return PermissionStatus.granted;
        }
      }

      if (requestResult != PermissionStatus.granted) {
        print('No external storage permission, using app-specific storage');
        return PermissionStatus.granted;
      }

      return requestResult;
    } else {
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
        // Try public Downloads folder
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          // Test write permission
          try {
            final testFile = File('${downloadsDir.path}/.test_write');
            await testFile.writeAsString('test');
            await testFile.delete();
            print('Using public Downloads directory');
            return downloadsDir;
          } catch (e) {
            print('No write access to public Downloads: $e');
          }
        }
        // Fallback: app-specific external storage
        Directory? externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final downloadSubDir = Directory('${externalDir.path}/Downloads');
          if (!await downloadSubDir.exists()) {
            await downloadSubDir.create(recursive: true);
          }
          print('Using app-specific external Downloads directory');
          return downloadSubDir;
        }
        // Fallback: app documents directory
        final appDocsDir = await getApplicationDocumentsDirectory();
        final downloadSubDir = Directory('${appDocsDir.path}/Downloads');
        if (!await downloadSubDir.exists()) {
          await downloadSubDir.create(recursive: true);
        }
        print('Using app-specific Documents/Downloads directory');
        return downloadSubDir;
      } else {
        // iOS: use documents directory
        final appDocsDir = await getApplicationDocumentsDirectory();
        final downloadSubDir = Directory('${appDocsDir.path}/Downloads');
        if (!await downloadSubDir.exists()) {
          await downloadSubDir.create(recursive: true);
        }
        return downloadSubDir;
      }
    } catch (e) {
      print('Error getting download directory: $e');
      try {
        return await getApplicationDocumentsDirectory();
      } catch (e2) {
        print('Error getting app documents directory: $e2');
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
      return 30;
    } catch (e) {
      print('Error getting Android version: $e');
      return 30;
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