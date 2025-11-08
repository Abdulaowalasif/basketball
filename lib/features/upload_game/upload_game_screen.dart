import 'package:basketball/widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes_name.dart';
import '../player_info/player_info_model/player_info_model.dart';

class UploadGameScreen extends StatefulWidget {
  const UploadGameScreen({super.key});

  @override
  State<UploadGameScreen> createState() => _UploadGameScreenState();
}

class _UploadGameScreenState extends State<UploadGameScreen> {
  final TextEditingController _youtubeUrlController = TextEditingController();

  @override
  void dispose() {
    _youtubeUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PlayerInfo? info = Get.arguments;
    if (info == null && Get.previousRoute != RoutesName.playerInfo) {
      Get.offNamed(RoutesName.playerInfo);
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
              ? () {
            Get.toNamed(
              RoutesName.processGame,
              arguments: {
                'videoUrl': _youtubeUrlController.text,
                'playerInfo': info,
              },
            );
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