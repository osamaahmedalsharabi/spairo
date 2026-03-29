import 'package:flutter/material.dart';
import 'package:sparioapp/Widgets/CustomButton.dart';
import 'package:sparioapp/Widgets/CustomTextField.dart';
import '../Core/Theme/app_colors.dart';
import '../Widgets/CustomDropdown.dart';

class OrdersPartCarPage extends StatefulWidget {
  const OrdersPartCarPage({super.key});

  @override
  State<OrdersPartCarPage> createState() => _OrdersPartCarPageState();
}

class _OrdersPartCarPageState extends State<OrdersPartCarPage> {
  // --- بيانات تجريبية ---
  final List<String> companies = [
    "تويوتا",
    "هيونداي",
    "كيا",
    "نيسان",
    "بي إم دبليو",
    "مرسيدس",
  ];

  final Map<String, List<String>> carsByCompany = {
    "تويوتا": ["كورولا", "كامري", "يارس"],
    "هيونداي": ["إلانترا", "سوناتا", "أكسنت"],
    "كيا": ["سبورتاج", "سيراتو", "سيلتوس"],
    "نيسان": ["ألتيما", "صني", "باترول"],
    "بي إم دبليو": ["M3", "X5", "320i"],
    "مرسيدس": ["C200", "E300", "G-Class"],
  };

  final List<String> conditions = ["جديد", "مستعمل"];

  final List<String> carYears = List.generate(
    2025 - 1980 + 1,
    (i) => (1980 + i).toString(),
  );

  // --- القيم المحددة ---
  String? selectedCompany;
  String? selectedCar;
  String? selectedYear;
  String? selectedCondition;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_forward),
            ),
          ],
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "طلب قطع غيار",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //-- نوع الشركة
                CustomDropTextField(
                  label: "شركة السيارة",
                  items: companies,
                  selectedValue: selectedCompany,
                  onChanged: (value) {
                    setState(() {
                      selectedCompany = value;
                      selectedCar = null;
                    });
                  },
                ),

                const SizedBox(height: 20),

                //-- اسم السيارة
                CustomDropTextField(
                  label: "اسم السيارة",
                  items: selectedCompany != null
                      ? carsByCompany[selectedCompany]!
                      : [],
                  selectedValue: selectedCar,
                  onChanged: (value) {
                    setState(() {
                      selectedCar = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                //-- موديل السيارة
                CustomDropTextField(
                  label: "موديل السيارة",
                  items: carYears,
                  selectedValue: selectedYear,
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                //-- حالة القطعة
                CustomDropTextField(
                  label: "حالة القطعة",
                  items: conditions,
                  selectedValue: selectedCondition,
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Text("رقم قطعة السيارة (إن وجد)"),
                CustomTextField(hint: "أدخل رقم القطعة"),

                const SizedBox(height: 16),

                Text("اسم قطعة السيارة"),
                CustomTextField(hint: "مثال: لمبة أمامية"),

                const SizedBox(height: 16),

                Text("تفاصيل قطعة السيارة (إن وجد)"),
                CustomTextField(hint: "اكتب وصفًا للقطعة"),

                const SizedBox(height: 22),

                //-- زر إضافة صورة
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.3,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.orange,
                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                //-- زر تأكيد الطلب
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
                      "تأكيد الطلب",
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
