import 'package:basketball/features/report/report_list_controller.dart';
import 'package:basketball/features/storage/storage_service.dart';
import 'package:basketball/routes/routes_name.dart';
import 'package:basketball/widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_elevated_button.dart';
import '../widgets/report_list_card.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportListController());
    final storage = Get.put(StorageService());
    bool isPlayer = storage.read('is_player');

    return Scaffold(
      appBar: CustomTitleAppbar(title: 'View Past Reports'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: isPlayer
                    ? controller.playerReportList.length
                    : controller.coachReportList.length,
                itemBuilder: (context, index) {
                  return ReportListCard(
                    reports: isPlayer
                        ? controller.playerReportList
                        : controller.coachReportList,
                    index: index,
                    onPressed: () {
                      Get.toNamed(
                        RoutesName.viewReport,
                        arguments: isPlayer
                            ? controller.playerReportList[index]
                            : controller.coachReportList[index],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: CustomElevatedButton(
                title: 'Done',
                routeName: storage.read("is_player")
                    ? RoutesName.playerInfo
                    : RoutesName.coachInfo,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
