import 'dart:convert';
import 'package:basketball/features/report/model/player_report_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoin.dart';
import '../../features/report/model/coach_report_model.dart';
import '../../features/storage/storage_service.dart';

class ReportListController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<CoachReportModel> coachReportList = <CoachReportModel>[].obs;
  RxList<PlayerReportModel> playerReportList = <PlayerReportModel>[].obs;

  final StorageService storageService = Get.put(StorageService());

  Future<void> getReport() async {
    isLoading.value = true;

    try {
      final bool isPlayer = storageService.read('is_player') as bool? ?? false;

      final String endpoint = isPlayer
          ? ApiEndpoints.getReportList
          : ApiEndpoints.getReportListCoach;

      final Uri url = Uri.parse(endpoint);
      final String? token = storageService.read('accessToken') as String?;

      if (token == null || token.isEmpty) {
        Get.showSnackbar(
          const GetSnackBar(
            title: 'Unauthorized',
            message: 'Token not found. Please log in again.',
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (isPlayer) {
          playerReportList.value = data
              .map((e) => PlayerReportModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          coachReportList.value = data
              .map((e) => CoachReportModel.fromJson(e))
              .toList();
        }
      } else {
        Get.showSnackbar(
          GetSnackBar(
            title: "Error",
            message: "Failed to load reports (${response.statusCode})",
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: "An error occurred: $e",
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getReport();
  }

  @override
  void onReady() {
    super.onReady();
    getReport();
  }
}
