import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Widgets/CustomTextField.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "الملف الشخصي",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          leading: const SizedBox(),
          actions: [
            IconButton(onPressed: () {
              Navigator.pushNamed(context, "/home");
            }, icon: Icon(Icons.arrow_forward))
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "المعلومات الشخصية",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 22),

                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: "صادق الرياني",
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_sharp),
                        color: Colors.grey,
                        iconSize: 28,
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: "Sadeqalryani127@gmail.com",
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_sharp),
                        color: Colors.grey,
                        iconSize: 28,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                Text(
                  "تغيير كلمة المرور",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 22),

                CustomTextField(hint: "كلمة المرور الحالية"),
                const SizedBox(height: 12),
                CustomTextField(hint: "كلمة المرور الجديدة"),
                const SizedBox(height: 12),
                CustomTextField(hint: "تأكيد كلمة المرور"),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "حفظ التغييرات",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
