import 'dart:convert';
import 'package:basketball/features/player_info/player_info_model/player_info_model.dart';
import 'package:basketball/features/player_info/player_info_model/player_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_endpoin.dart';
import '../../storage/storage_service.dart';

class PlayerInfoController extends GetxController {
  var selectedPosition = 'Post'.obs;
  var selectedTeam = 'Club'.obs;
  var selectedGender = 'Male'.obs;

  var playerName = ''.obs;
  var jerseyNumber = ''.obs;
  var height = ''.obs;
  var jerseyColor = ''.obs;
  var classYear = ''.obs;
  var gameContext = ''.obs;
  var opponentTeam = ''.obs;
  var playerID = 0.obs;

  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  RxList<PlayerResponse> player = <PlayerResponse>[].obs;

  List<String> get playerNames => player.map((e) => e.fullName).toList();
  List<int> get playerId => player.map((e) => e.id).toList();

  int? getPlayerIdByName(String name) {
    return player.firstWhereOrNull((e) => e.fullName == name)?.id;
  }

  List<String> jerseyNumbers = ['10', '23', '45', '12', '7', '33', '24', '8', '11', '42'];
  List<String> heights = ['5\'6"', '5\'8"', '5\'10"', '6\'0"', '6\'2"', '6\'4"', '6\'6"', '6\'8"'];
  List<String> jerseyColors = ['Red', 'Blue', 'Green', 'Black', 'White', 'Yellow', 'Orange'];
  List<String> classYears = ['2020', '2021', '2022', '2023', '2024', '2025', '2026', '2027'];
  List<String> gameContexts = ['Regular Season', 'Playoffs', 'Tournament', 'Practice Game'];
  List<String> teamTypes = ['Club', 'Middle school', 'High School', 'College'];
  List<String> gender = ["Male", "Female"];
  List<String> opponentTeams = ['Team A', 'Team B', 'Team C', 'Team D', 'Team E'];
  List<String> selectedPositions = [
    'Post',
    'Wing',
    'Guard',
    'Center',
    'Forward',
    'Defender',
    'Point Guard',
    'Shooting Guard',
  ];

  final performanceNoteController = TextEditingController();

  int convertHeight(String heightStr) {
    try {
      final parts = heightStr.split('\'');
      if (parts.length == 2) {
        final feet = int.tryParse(parts[0]) ?? 0;
        final inches = int.tryParse(parts[1].replaceAll('"', '')) ?? 0;
        return feet * 12 + inches; // Return total inches as number
      }
    } catch (e) {
      print('Error converting height: $e');
    }
    // If format is unexpected, try to extract numbers
    final numbers = RegExp(r'\d+').allMatches(heightStr);
    if (numbers.isNotEmpty) {
      return int.tryParse(numbers.first.group(0) ?? '0') ?? 0;
    }
    return 0;
  }

  String convertGender(String gender) {
    // Convert to match server expectations
    switch (gender.toLowerCase()) {
      case 'male':
        return 'M'; // or 'Male' - check with your API documentation
      case 'female':
        return 'F'; // or 'Female' - check with your API documentation
      default:
        return 'M'; // default fallback
    }
  }

  bool validateForm() {
    if (playerName.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a player name');
      return false;
    }
    if (jerseyNumber.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a jersey number');
      return false;
    }
    if (height.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select height');
      return false;
    }
    if (jerseyColor.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select jersey color');
      return false;
    }
    if (classYear.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select class year');
      return false;
    }
    if (gameContext.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select game context');
      return false;
    }
    if (opponentTeam.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select opponent team');
      return false;
    }
    return true;
  }

  PlayerInfo toModel() {
    return PlayerInfo(
      playerName: playerID.value.toString(),
      jerseyNumber: jerseyNumber.value,
      height: convertHeight(height.value).toString(), // Convert to string for model
      jerseyColor: jerseyColor.value,
      position: selectedPosition.value,
      classYear: classYear.value,
      gameContext: gameContext.value,
      teamType: selectedTeam.value,
      gender: convertGender(selectedGender.value),
      opponentTeam: opponentTeam.value,
      performanceNote: performanceNoteController.text.trim(),
      tournamentName: '',
      gameResult: '',
      opponentFaced: '',
      scoreOrMargin: '',
      gameFlowDetails: '',
    );
  }

  Future<void> getPlayer() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final url = Uri.parse(ApiEndpoints.userLists);
      final token = Get.find<StorageService>().read('accessToken');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          throw Exception('Empty response from server');
        }

        final List<dynamic> users = jsonDecode(responseBody);
        player.value = users.map((e) => PlayerResponse.fromJson(e)).toList();

        if (player.isEmpty) {
          Get.snackbar(
            'Info',
            'No players found. Please add players first.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. You don\'t have permission to view players.');
      } else if (response.statusCode == 404) {
        throw Exception('Players endpoint not found.');
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch player data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 5),
      );
      print('Error fetching players: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retryGetPlayer() async {
    await getPlayer();
  }

  void clearForm() {
    selectedPosition.value = 'Post';
    selectedTeam.value = 'Club';
    selectedGender.value = 'Male';
    playerName.value = '';
    jerseyNumber.value = '';
    height.value = '';
    jerseyColor.value = '';
    classYear.value = '';
    gameContext.value = '';
    opponentTeam.value = '';
    playerID.value = 0;
    performanceNoteController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    getPlayer();
  }

  @override
  void onClose() {
    performanceNoteController.dispose();
    super.onClose();
  }
}