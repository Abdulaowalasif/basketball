import 'package:basketball/routes/routes_name.dart';
import 'package:basketball/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: CustomButton(
        buttonText: 'Return To Home',
        routeName: RoutesName.playerInfo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Oups!!', style: Theme.of(context).textTheme.headlineMedium),
            Image.asset('assets/images/error.png'),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
