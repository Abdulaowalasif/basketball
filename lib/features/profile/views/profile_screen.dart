import 'package:basketball/features/storage/storage_service.dart';
import 'package:basketball/routes/routes_name.dart';
import 'package:basketball/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../report/widgets/StatBar.dart';
import '../../report/widgets/section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.put(StorageService());
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final player = args['data']?['player'] ?? {};
    final report = args['data']?['report'] ?? {};

    final String playerName = args['full_name']?.toString() ?? 'Unknown';

    final String imageUrl =
        player['image'] ??
        'https://i.pravatar.cc/150?u=${player['id'] ?? 'default'}';
    final String jerseyNumber = player['jersey_number']?.toString() ?? '';
    final String height = player['height']?.toString() ?? '';
    final String position = player['position'] ?? '';
    final String classYear = player['class_year'] ?? '';
    final String team = player['team'] ?? '';
    final String gender = player['gender'] ?? '';
    final String opponentTeam = player['opponent_team_name'] ?? '';
    final String performanceNote = player['performance_note'] ?? '';
    final String tournamentName = player['tournament_name'] ?? '';
    final String gameResult = player['game_result'] ?? '';
    final String opponentFaced = player['opponent_faced'] ?? '';
    final String scoreOrMargin = player['score_or_margin'] ?? '';
    final String gameFlowDetails = player['game_flow_details'] ?? '';
    final String gameVideo = player['game_video'] ?? '';

    final String reportTitle = report['report_title'] ?? '';
    final String overview = report['overview'] ?? '';
    final List strengths = report['strengths'] ?? [];
    final List weaknesses = report['weaknesses'] ?? [];
    final String projection = report['projection'] ?? '';
    final double fgPercent = (report['field_goal_percentage'] ?? 0).toDouble();
    final double rebounds = (report['rebounds'] ?? 0).toDouble();
    final double assists = (report['assists'] ?? 0).toDouble();
    final double stealsBlocks = (report['steals_and_blocks'] ?? 0).toDouble();

    final bool isPlayer = Get.put(StorageService()).read('is_player');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello!',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.offAllNamed(RoutesName.signIn);
                Get.snackbar(
                  'Logged Out',
                  'You have been logged out successfully.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
                storage.clear();
              },
              child: Icon(Icons.menu, color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    playerName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            if (overview.isNotEmpty)
              Section(title: 'Overview', content: overview),
            if (strengths.isNotEmpty)
              Section(
                title: 'Strengths',
                content: strengths.map((e) => '• $e').join('\n'),
              ),
            if (weaknesses.isNotEmpty)
              Section(
                title: 'Weaknesses',
                content: weaknesses.map((e) => '• $e').join('\n'),
              ),
            if (projection.isNotEmpty)
              Section(title: 'Projection', content: projection),
            const SizedBox(height: 16),
            const Text(
              'Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Get is play or not
            isPlayer ?
              StatBar(title: 'Field Goal % (FG%)', value: fgPercent / 100)
            : const SizedBox.shrink(),
            isPlayer ? StatBar(title: 'Rebounds (RPG)', value: rebounds / 100):  const SizedBox.shrink(),
            isPlayer ? StatBar(title: 'Assists (APG)', value: assists / 100) : const SizedBox.shrink(),
            isPlayer ? StatBar(title: 'Steals & Blocks', value: stealsBlocks / 100): const SizedBox.shrink(),
            const SizedBox(height: 24),
            Text(
              args['data']?['message'] ??
                  'This report was built using uploaded game film and contextual data.',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              title: 'View all reports',
              routeName: RoutesName.reportList,
              imagePath: 'assets/icons/all_download.png',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
