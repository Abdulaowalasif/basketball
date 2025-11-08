import 'package:basketball/core/constants/user_enum.dart';
import 'package:basketball/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompactScreen extends StatefulWidget {
  const CompactScreen({super.key});

  @override
  State<CompactScreen> createState() => _CompactScreenState();
}

class _CompactScreenState extends State<CompactScreen> {
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Select Player or Coach',
                  style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 17,
                    fontFamily: 'Poppins',)),
              const SizedBox(height: 100),
              _buildRoleButton('Player',),
              const SizedBox(height: 30),
              _buildRoleButton('Coach'),
              const SizedBox(height: 150),
              ElevatedButton(
                onPressed: selectedRole.isEmpty ? null : selectedRole ==
                    'Player' ? () {
                  Get.toNamed(
                      RoutesName.signUp,
                      arguments: {'userType': UserType.player}
                  );
                } : () {
                  Get.toNamed(
                      RoutesName.signUp,
                      arguments: {'userType': UserType.coach}
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE4742B),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                    "Continue", style: TextStyle(
                    color: Colors.white, fontFamily: 'Poppins')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    final isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = role),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDE8DC) : const Color(0xFFFFF3EC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected ? const Color(0xFFE4742B) : Colors.transparent),
        ),
        child: Center(child: Text(
            role, style: const TextStyle(fontWeight: FontWeight.w500))),
      ),
    );
  }
}
