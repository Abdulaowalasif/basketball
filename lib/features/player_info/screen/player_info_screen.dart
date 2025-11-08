import 'package:basketball/widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/routes_name.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_toggle_button.dart';
import '../controller/player_info_controller.dart';

class PlayerInfoScreen extends StatelessWidget {
  const PlayerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerInfoController());

    return Scaffold(
      appBar: CustomTitleAppbar(title: "Player Information"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Obx(
                  () => Expanded(
                    child: CustomDropdown(
                      label: "Player Name",
                      items: controller.playerNames,
                      onChanged: (val) {
                        controller.playerName.value = val!;
                        controller.playerID.value =
                            controller.getPlayerIdByName(val) ?? 0;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown(
                    label: "Jersey Number",
                    items: controller.jerseyNumbers,
                    onChanged: (val) => controller.jerseyNumber.value = val!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Height & Jersey Color
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    label: "Height",
                    items: controller.heights,
                    onChanged: (val) => controller.height.value = val!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown(
                    label: "Jersey Color",
                    items: controller.jerseyColors,
                    onChanged: (val) => controller.jerseyColor.value = val!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Position
            Obx(
              () => CustomToggleButton(
                options: controller.selectedPositions,
                selected: controller.selectedPosition.value,
                onSelected: (val) => controller.selectedPosition.value = val,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    label: "Class year",
                    items: controller.classYears,
                    onChanged: (val) => controller.classYear.value = val!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomDropdown(
                    label: "Game context",
                    items: controller.gameContexts,
                    onChanged: (val) => controller.gameContext.value = val!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Team
            Obx(
              () => CustomToggleButton(
                options: controller.teamTypes,
                selected: controller.selectedTeam.value,
                onSelected: (val) => controller.selectedTeam.value = val,
              ),
            ),
            const SizedBox(height: 12),

            /// Gender
            Obx(
              () => CustomToggleButton(
                options: controller.gender,
                selected: controller.selectedGender.value,
                onSelected: (val) => controller.selectedGender.value = val,
              ),
            ),
            const SizedBox(height: 12),

            /// Opponent Team
            CustomDropdown(
              label: "Opponent team name",
              items: controller.opponentTeams,
              onChanged: (val) => controller.opponentTeam.value = val!,
            ),
            const SizedBox(height: 12),

            CustomTextInput(
              label: "Performance note",
              controller: controller.performanceNoteController,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            if (controller.playerName.value.isEmpty ||
                controller.jerseyNumber.value.isEmpty ||
                controller.height.value.isEmpty ||
                controller.jerseyColor.value.isEmpty ||
                controller.selectedPosition.value.isEmpty ||
                controller.classYear.value.isEmpty ||
                controller.gameContext.value.isEmpty ||
                controller.selectedTeam.value.isEmpty ||
                controller.selectedGender.value.isEmpty ||
                controller.opponentTeam.value.isEmpty ||
                controller.performanceNoteController.text.isEmpty) {
              Get.snackbar(
                'Required',
                'Please fill in all fields',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.8),
                colorText: Colors.white,
              );
              return;
            }

            final info = controller.toModel();
            Get.toNamed(RoutesName.scoutingContext, arguments: info);
          },
          child: const Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
