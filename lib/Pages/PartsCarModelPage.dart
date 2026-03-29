import 'package:flutter/material.dart';

import '../Company/FackDataModel.dart';

class PartsScreen extends StatelessWidget {
  final String model;

  const PartsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE8C8),
        title: Text("قطع $model"),
      ),

      body: ListView.builder(
        itemCount: fakeParts.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFFFFE8C8),
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(fakeParts[index]),
            ),
          );
        },
      ),
    );
  }
}
