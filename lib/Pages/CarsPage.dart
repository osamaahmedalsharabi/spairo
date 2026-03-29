import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'CarModelPage.dart';
import '../Company/FakeModel.dart';

class CarsPage extends StatelessWidget {
  final Company company;

  const CarsPage({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE8C8),
        title: Text(company.name),
      ),

      body: ListView.builder(
        itemCount: company.cars.length,
        itemBuilder: (context, index) {
          final car = company.cars[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ModelsScreen(car: car),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Card(
                color: AppColors.backgroundSlightlyDarker2,
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        image: DecorationImage(
                            image: AssetImage("assets/Toyota/Toyota Camry.png"),
                          fit: BoxFit.fill,
                        )
                      ),
                      child: Text(""),
                    ),

                    Card(
                      color: const Color(0xFFFFE8C8),
                      margin: const EdgeInsets.only(bottom: 18, left: 12, right: 12),
                      child: ListTile(
                        title: Text(car.name),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
