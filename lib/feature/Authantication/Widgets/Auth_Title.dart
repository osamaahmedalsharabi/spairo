import 'package:flutter/material.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String title;

  const AuthHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 25), // Padding equivalent to icon size
            // Text(
            //   title,
            //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            // IconButton(
            //   icon: const Icon(Icons.arrow_forward),
            //   onPressed: () => Navigator.maybePop(context),
            // ),
          ],
        ),
        const SizedBox(height: 0),
        Image.asset("assets/logo-spairo.png", height: 70),
        const SizedBox(height: 10),
        const Text(
          "Spairo",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
