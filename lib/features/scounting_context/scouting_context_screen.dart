import 'package:basketball/widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes_name.dart';
import '../player_info/player_info_model/player_info_model.dart';

class ScoutingContextScreen extends StatelessWidget {
  const ScoutingContextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayerInfo info = Get.arguments;
    final TextEditingController tournamentName = TextEditingController();
    final TextEditingController gameResult = TextEditingController();
    final TextEditingController opponentFaced = TextEditingController();
    final TextEditingController scoreOrMargin = TextEditingController();
    final TextEditingController gameFlowDetails = TextEditingController();

    return Scaffold(
      appBar: CustomTitleAppbar(title: 'Scouting Context'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (tournamentName.text.isEmpty ||
                  gameResult.text.isEmpty ||
                  opponentFaced.text.isEmpty ||
                  scoreOrMargin.text.isEmpty ||
                  gameFlowDetails.text.isEmpty) {
                Get.snackbar(
                  'Required Fields',
                  'Please fill in all the fields before continuing.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
                return;
              }

              PlayerInfo playerInfo = PlayerInfo(
                tournamentName: tournamentName.text,
                gameResult: gameResult.text,
                opponentFaced: opponentFaced.text,
                scoreOrMargin: scoreOrMargin.text,
                gameFlowDetails: gameFlowDetails.text,
                playerName: info.playerName,
                jerseyNumber: info.jerseyNumber,
                height: info.height,
                jerseyColor: info.jerseyColor,
                position: info.position,
                classYear: info.classYear,
                gameContext: info.gameContext,
                teamType: info.teamType,
                gender: info.gender,
                opponentTeam: info.opponentTeam,
                performanceNote: info.performanceNote,
              );

              Get.toNamed(RoutesName.uploadGame, arguments: playerInfo);
            },

            child: Text(
              "Next",
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(context, 'Tournament name', tournamentName),
            const SizedBox(height: 20),
            _buildInfoSection(context, 'Game result', gameResult),
            const SizedBox(height: 20),
            _buildInfoSection(context, 'Opponent faced', opponentFaced),
            const SizedBox(height: 20),
            _buildInfoSection(context, 'Score or margin', scoreOrMargin),
            const SizedBox(height: 20),
            _buildInfoSection(context, 'Game flow details', gameFlowDetails),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
