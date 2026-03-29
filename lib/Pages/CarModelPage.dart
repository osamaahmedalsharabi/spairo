import 'package:flutter/material.dart';
import '../Company/FakeModel.dart';
import '../Core/Theme/app_colors.dart';
import 'PartsCarModelPage.dart';

class ModelsScreen extends StatelessWidget {
  final Car car;

  const ModelsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSlightlyDarker2,
        title: Text(car.name),
      ),

      body: ListView.builder(
        itemCount: car.models.length,
        itemBuilder: (context, index) {
          final model = car.models[index];

          return Card(
            color: const Color(0xFFFFE8C8),
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text("موديل $model"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PartsScreen(model: model),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
