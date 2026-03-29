import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background.withOpacity(0.01),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black,size: 33,),
            onPressed: () {
              Navigator.pushNamed(context, "/home");
            },
          ),
        ],
        leading: Text(""),
        title: const Text(
          'الاشعارات',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        color: Colors.white,
                        width: 38,
                        height: 30,
                        child: Text(
                            textAlign: TextAlign.center,
                            "2",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 1.0,),
                    Text(
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        "New    ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                  ],
                ),
              ),
            ],
          ),

          CardNotFication(),
          CardNotFication(),
          CardNotFication(),
          CardNotFication(),

        ],
      ),
    );
  }
}



class CardNotFication extends StatelessWidget {
  const CardNotFication({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        elevation: 2,
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("9:00 AM",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
              SizedBox(width: 8,),
              Expanded(child: Text("DisAccount for the Eid 50% for every user in spairo ")),
              CircleAvatar(
                radius: 44,
                backgroundImage: AssetImage("assets/1.JPG"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
