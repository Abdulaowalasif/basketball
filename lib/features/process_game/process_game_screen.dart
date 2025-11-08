import 'dart:convert';
import 'package:basketball/routes/routes_name.dart';
import 'package:basketball/widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoin.dart';
import '../player_info/player_info_model/player_info_model.dart';
import '../storage/storage_service.dart';

class ProcessGameScreen extends StatefulWidget {
  const ProcessGameScreen({super.key});

  @override
  State<ProcessGameScreen> createState() => _ProcessGameScreenState();
}

class _ProcessGameScreenState extends State<ProcessGameScreen> {
  bool _loading = true;
  String? _error;
  bool _success = false;
  String? _taskId;
  String? _message;
  Map<String, dynamic>? _responseData;

  @override
  void initState() {
    super.initState();
    _postGameData();
  }

  Future<void> _postGameData() async {
    try {
      final args = Get.arguments;
      if (args == null ||
          args['playerInfo'] == null ||
          args['videoUrl'] == null) {
        setState(() {
          _loading = false;
          _error = 'Missing player info or video URL.';
        });
        return;
      }

      final PlayerInfo playerInfo = args['playerInfo'];
      final String videoUrl = args['videoUrl'];
      final dynamic tokenValue = Get.put(StorageService()).read('accessToken');
      final String? token = tokenValue is String ? tokenValue : null;

      if (token == null || token.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'Unauthorized: Token not found. Please log in again.';
        });
        return;
      }

      final uri = Uri.parse(ApiEndpoints.createReport);
      final body = {
        'player_name': playerInfo.playerName,
        'jersey_number': playerInfo.jerseyNumber,
        'jersey_color': playerInfo.jerseyColor,
        'height': playerInfo.height,
        'position': playerInfo.position,
        'class_year': playerInfo.classYear,
        'game_context': playerInfo.gameContext,
        'team': playerInfo.teamType,
        'gender': playerInfo.gender,
        'opponent_team_name': playerInfo.opponentTeam,
        'performance_note': playerInfo.performanceNote,
        'tournament_name': playerInfo.tournamentName,
        'game_result': playerInfo.gameResult,
        'opponent_faced': playerInfo.opponentFaced,
        'score_or_margin': playerInfo.scoreOrMargin,
        'game_flow_details': playerInfo.gameFlowDetails,
        'game_video': videoUrl,
      };

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        setState(() {
          _loading = false;
          _success = true;
          _message = 'Game processed successfully!';
          _responseData = data;
          _taskId = data['task_id']?.toString();
        });
      } else {
        setState(() {
          _loading = false;
          _error = 'Failed: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Network error: $e';
      });
    }
  }

  void _retryUpload() {
    setState(() {
      _loading = true;
      _error = null;
      _success = false;
      _taskId = null;
      _message = null;
      _responseData = null;
    });
    _postGameData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomTitleAppbar(title: 'Processing Game'),
      bottomNavigationBar: _success
          ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.offAllNamed(
                RoutesName.profile,
                arguments: {
                  'data': _responseData,
                },
              );
            },
            child: Text(
              'Done',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: Colors.white),
            ),
          ),
        ),
      )
          : _error != null
          ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _retryUpload,
            child: Text(
              'Retry',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: Colors.white),
            ),
          ),
        ),
      )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_loading) ...[
                Image.asset('assets/images/loading.png', height: 100),
                const SizedBox(height: 20),
                Text(
                  'Processing your game data...',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'This may take a few moments',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ] else if (_success) ...[
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                Text(
                  _message ?? 'Game processed successfully!',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Your game data has been uploaded and report generation has started.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (_taskId != null) ...[
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Task ID: $_taskId',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(height: 5),
                        SelectableText(
                          _taskId!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                            color: Colors.blue[600],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else if (_error != null) ...[
                const Icon(Icons.error_outline, color: Colors.red, size: 80),
                const SizedBox(height: 20),
                Text(
                  'Upload Failed',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    _error!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.red[700]),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}