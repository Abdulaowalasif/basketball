import 'dart:convert';

import 'package:basketball/core/constants/api_endpoin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/routes_name.dart';
import '../../../widgets/custom_title_appbar.dart';
import '../../storage/storage_service.dart';

class UploadFilmScreen extends StatefulWidget {
  const UploadFilmScreen({super.key});

  @override
  State<UploadFilmScreen> createState() => _UploadFilmScreenState();
}

class _UploadFilmScreenState extends State<UploadFilmScreen> {
  final TextEditingController _youtubeUrlController = TextEditingController();

  @override
  void dispose() {
    _youtubeUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = Get.arguments?['teamInfo'];
    if (info == null && Get.previousRoute != RoutesName.coachInfo) {
      Get.offNamed(RoutesName.coachInfo);
      return const SizedBox.shrink();
    }

    if (info == null) {
      return Scaffold(
        appBar: CustomTitleAppbar(title: 'Upload Game'),
        body: const Center(child: Text('Player info not found')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomTitleAppbar(title: 'Upload Game'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _youtubeUrlController.text.isNotEmpty
              ? () async {
            final teamInfo = info; // This should be a Map<String, dynamic>
            final body = {
              "opponent_team_name": teamInfo['opponent'] ?? '',
              "jersey_color": teamInfo['jerseyColor'] ?? '',
              "gender": teamInfo['gender'] ?? '',
              "circuit_or_level": teamInfo['level'] ?? '',
              "game_date": teamInfo['date'] ?? '',
              "performance_note": teamInfo['note'] ?? '',
              "youtube_link": _youtubeUrlController.text.trim(),
            };

            final url = Uri.parse(ApiEndpoints.createReportCoach);
            try {
              String token = Get.put(StorageService()).read('accessToken') ?? '';
              final response = await http.post(
                url,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode(body),
              );

              if (response.statusCode == 200 || response.statusCode == 201) {
                // Success: handle navigation or show success message
                Get.snackbar('Success', 'Game uploaded successfully');
                Get.offAllNamed(
                  RoutesName.profile,
                  arguments: {
                    'data': jsonDecode(response.body),
                  },
                );
              } else {
                // Error: show error message
                Get.snackbar('Error', 'Failed: ${response.body}');
              }
            } catch (e) {
              Get.snackbar('Network Error', e.toString());
            }
          }
              : null,
          child: Text(
            'Process Game',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter YouTube Video URL',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _youtubeUrlController,
              decoration: const InputDecoration(
                labelText: 'YouTube Video URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }
}