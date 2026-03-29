import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../Pages/CarsPage.dart';
import '../Company/FackDataModel.dart';

class CompanyListWidget extends StatelessWidget {
  const CompanyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 12,),
          const Text(
            "الشركات    ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            color: AppColors.background,
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: companies.length,
                itemBuilder: (context, i) {
                  final c = companies[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CarsPage(company: c),
                      ),
                    ),

                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2,vertical: 33),
                      child: SizedBox(
                        width: 140,
                        child: Card(
                          color: AppColors.background,
                          elevation: 22,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(c.logo, height: 60),
                              const SizedBox(height: 10),
                              Text(c.name),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
