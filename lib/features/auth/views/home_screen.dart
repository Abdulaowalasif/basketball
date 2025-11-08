import 'package:basketball/features/storage/storage_service.dart';
import 'package:basketball/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StorageService storageService = Get.put(StorageService());
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/splash_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          // Centered Texts
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Game\nYour Breakdown',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Don't get comfortable",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 70,
            left: 30,
            right: 30,
            child: ElevatedButton(
              onPressed: () {
                String? token = storageService.read('accessToken');
                bool isPlayer = storageService.read('is_player') ?? false;

                if (token != null && token.isNotEmpty) {
                  if (isPlayer) {
                    Get.offNamed(RoutesName.playerInfo);
                  } else {
                    Get.offNamed(RoutesName.coachInfo);
                  }
                } else {
                  Get.offNamed(RoutesName.signIn);
                }
              },
              child: Text(
                'Get Started', // Fixed spelling
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
