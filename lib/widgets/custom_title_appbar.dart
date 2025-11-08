import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTitleAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomTitleAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
