// In lib/features/coach/team_info/controller/teamInfo_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamInfoController extends GetxController {
  var selectedOpponent = ''.obs;
  var selectedJerseyColor = ''.obs;
  var selectedGender = ''.obs;
  var selectedLevel = ''.obs;
  var selectedDate = ''.obs;
  var note = ''.obs;

  final List<String> opponents = ['Team A', 'Team B', 'Team C', 'Team D', 'Team E'];
  final List<String> jerseyColors = ['Red', 'Blue', 'Green', 'Black', 'White', 'Yellow', 'Orange'];
  final List<String> genders = ['M', 'F'];
  final List<String> levels = [
    '13U',
    '14U',
    '15U',
    '16U',
    '17U',
    'Middle School Game',
    'High School Game',
  ];

  final noteController = TextEditingController();

  // Add this method
  void selectGender(String gender) => selectedGender.value = gender;

  // Add this method
  void setDate(String date) => selectedDate.value = date;

  // Add this method
  Map<String, String> getTeamInfo() {
    return {
      'opponent': selectedOpponent.value,
      'jerseyColor': selectedJerseyColor.value,
      'gender': selectedGender.value,
      'level': selectedLevel.value,
      'date': selectedDate.value,
      'note': note.value,
    };
  }
  bool validateInputs() {
    if (selectedOpponent.value.isEmpty ||
        selectedJerseyColor.value.isEmpty ||
        selectedLevel.value.isEmpty ||
        selectedGender.value.isEmpty ||
        selectedDate.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }


  @override
  void onInit() {
    selectedOpponent.value = opponents.first;
    selectedJerseyColor.value = jerseyColors.first;
    selectedGender.value = genders.first;
    selectedLevel.value = levels.first;
    super.onInit();
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}