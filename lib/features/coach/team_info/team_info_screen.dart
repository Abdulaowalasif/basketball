import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/routes_name.dart';
import '../../../widgets/custom_dropdown.dart';
import 'controller/teamInfo_controller.dart';

class TeamInfoScreen extends StatelessWidget {
  TeamInfoScreen({super.key});

  // Injecting the controller using GetX
  final TeamInfoController controller = Get.put(TeamInfoController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get current theme for styling

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Center(
          child: Text("Team Info", style: theme.textTheme.headlineMedium),
        ),
        iconTheme: theme.iconTheme,
      ),
      body: Obx(
            () =>
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Dropdown for selecting opponent
                  CustomDropdown(label: 'Opponent',
                    items: controller.opponents,
                    onChanged: (val) {
                      controller.selectedOpponent.value = val ?? '';
                    },),
                  const SizedBox(height: 16),

                  // Dropdown for selecting jersey color
                  CustomDropdown(label: 'Jersey Color',
                    items: controller.jerseyColors,
                    onChanged: (val) {
                      controller.selectedJerseyColor.value = val ?? '';
                    },),
                  const SizedBox(height: 16),

                  // Dropdown for selecting level
                  CustomDropdown(
                    label: 'Level',
                    items: controller.levels,
                    value: controller.selectedLevel.value,
                    onChanged: (val) {
                      controller.selectedLevel.value = val ?? '';
                    },
                  ),
                  const SizedBox(height: 16),

                  // Custom UI for selecting gender
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender', style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Gender: Male
                          _buildGenderTab(
                            context,
                            label: 'Male',
                            isSelected: controller.selectedGender.value == 'M',
                            onTap: () => controller.selectGender('M'),
                          ),
                          const SizedBox(height: 8),
                          // Gender: Female
                          _buildGenderTab(
                            context,
                            label: 'Female',
                            isSelected: controller.selectedGender.value == 'F',
                            onTap: () => controller.selectGender('F'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date picker for game date
                  _buildDateField(context),
                  const SizedBox(height: 16),

                  // Multiline text field for optional note
                  _buildNoteField(context),
                  const SizedBox(height: 24),

                  // Continue button to go to UploadFilmScreen with selected data
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.validateInputs()) {
                          final teamInfo = controller
                              .getTeamInfo(); // Collect user input
                          Get.toNamed(
                            RoutesName.uploadFile,
                            arguments: {'teamInfo': teamInfo},
                          ); // Navigate with arguments
                        }
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  /// Widget to build gender selection tab (Male / Female)
  Widget _buildGenderTab(BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.grey, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isSelected
                ? theme.primaryColor
                : theme.textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // /// Widget to build dropdown (custom style)
  // StatefulBuilder _buildDropdown(BuildContext context, {
  //   required String label,
  //   required List<String> items,
  //   required String value,
  //   required Function(String?) onChanged,
  // }) {
  //   final theme = Theme.of(context);
  //   bool isExpanded = false;
  //
  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             label,
  //             style: theme.textTheme.bodyMedium?.copyWith(
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               // Collapsed dropdown view
  //               Material(
  //                 color: Colors.transparent,
  //                 borderRadius: BorderRadius.circular(8),
  //                 child: InkWell(
  //                   onTap: () => setState(() => isExpanded = !isExpanded),
  //                   borderRadius: BorderRadius.circular(8),
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 16,
  //                       vertical: 16,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFFFFF2EA),
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           value.isNotEmpty ? value : 'Select',
  //                           style: theme.textTheme.bodyMedium?.copyWith(
  //                             color: value.isNotEmpty
  //                                 ? Colors.black87
  //                                 : Colors.grey,
  //                           ),
  //                         ),
  //                         Icon(
  //                           isExpanded ? Icons.expand_less : Icons.expand_more,
  //                           color: Colors.black54,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               // Expanded dropdown list
  //               if (isExpanded) ...[
  //                 const SizedBox(height: 4),
  //                 Container(
  //                   padding: const EdgeInsets.all(8.0),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: theme.scaffoldBackgroundColor,
  //                   ),
  //                   child: Column(
  //                     children: items
  //                         .expand(
  //                           (item) =>
  //                       [
  //                         const SizedBox(height: 4),
  //                         Material(
  //                           elevation: 2,
  //                           borderRadius: BorderRadius.circular(6),
  //                           color: theme.inputDecorationTheme.fillColor,
  //                           child: InkWell(
  //                             onTap: () {
  //                               onChanged(item);
  //                               setState(() => isExpanded = false);
  //                             },
  //                             borderRadius: BorderRadius.circular(6),
  //                             child: Container(
  //                               padding: const EdgeInsets.symmetric(
  //                                 horizontal: 16,
  //                                 vertical: 14,
  //                               ),
  //                               decoration: BoxDecoration(
  //                                 color: item == value
  //                                     ? theme.colorScheme.primary
  //                                     .withOpacity(0.1)
  //                                     : theme
  //                                     .inputDecorationTheme
  //                                     .fillColor,
  //                                 borderRadius: BorderRadius.circular(6),
  //                               ),
  //                               child: Text(
  //                                 item,
  //                                 style: theme.textTheme.bodyMedium
  //                                     ?.copyWith(
  //                                   fontWeight: item == value
  //                                       ? FontWeight.bold
  //                                       : FontWeight.normal,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                         .skip(1)
  //                         .toList(), // Skip leading spacing
  //                   ),
  //                 ),
  //               ],
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  /// Widget to build date picker field
  Widget _buildDateField(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game Date', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              // Format to YYYY-MM-DD
              controller.setDate(picked.toString().split(' ')[0]);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: theme.inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              controller.selectedDate.value.isNotEmpty
                  ? controller.selectedDate.value
                  : 'Select Date',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  /// Widget to build the note input field
  Widget _buildNoteField(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Note', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        TextField(
          onChanged: (val) => controller.note.value = val,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Write any note here...',
            fillColor: theme.inputDecorationTheme.fillColor,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
