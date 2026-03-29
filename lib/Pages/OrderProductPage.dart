import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Widgets/CustomButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class OrderStepperPage extends StatefulWidget {
  @override
  State<OrderStepperPage> createState() => _OrderStepperPageState();
}

class _OrderStepperPageState extends State<OrderStepperPage> {
  int _currentStep = 0;

  String? shippingMethod;
  String? selectedPayment;
  final walletNumberCtrl = TextEditingController();

  /// Step 2 — Address
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text("إتمام الطلب"),
          centerTitle: true,
        ),
        body: Container(
          color: AppColors.background,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            controlsBuilder: (context, details) =>
                const SizedBox(), // hide default buttons
            onStepContinue: () {
              if (_currentStep < 2) setState(() => _currentStep++);
            },
            onStepCancel: () {
              if (_currentStep > 0) setState(() => _currentStep--);
            },
            steps: [
              stepShipping(),
              stepAddress(),
              stepPayment(),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------- STEP 1 — Shipping --------------------------
  Step stepShipping() {
    return Step(
      stepStyle: StepStyle(
        color: Colors.orange,
        connectorColor: Colors.blue,
      ),
      title: const Text("الشحن"),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("اختر طريقة الشحن:"),
          const SizedBox(height: 12),
          shippingOption(
            value: "cod",
            title: "الدفع عند الاستلام",
            subtitle: "التسليم من المكان",
            icon: Icons.local_shipping,
            cost: "500 ريال",
          ),
          shippingOption(
            value: "later",
            title: "اشتري الآن وادفع لاحقاً",
            subtitle: "يرجى تحديد طريقة الدفع",
            icon: Icons.payment,
            cost: "مجاني",
          ),
          const SizedBox(height: 24),
          orangeButton("التالي", () => setState(() => _currentStep = 1)),
        ],
      ),
    );
  }

  Widget shippingOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required String cost,
  }) {
    return Column(
      children: [
        RadioListTile(
          value: value,
          groupValue: shippingMethod,
          activeColor: Colors.orange,
          onChanged: (v) => setState(() => shippingMethod = v),
          title: Text(title),
          subtitle: Text(subtitle),
          secondary: Icon(icon, color: Colors.orange),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(cost,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.orange)),
        ),
        const Divider(color: Colors.orange),
      ],
    );
  }

  // -------------------------- STEP 2 — Address --------------------------
  Step stepAddress() {
    return Step(
      stepStyle: StepStyle(
        color: Colors.orange,
        connectorColor: Colors.blue,
      ),
      title: const Text("العنوان"),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          borderedField(nameCtrl, "الاسم كامل"),
          borderedField(emailCtrl, "البريد الإلكتروني"),
          borderedField(addressCtrl, "العنوان"),
          borderedField(cityCtrl, "المدينة"),
          borderedField(detailsCtrl, "رقم الطابق ، رقم الشقة"),
          const SizedBox(height: 20),
          orangeButton("التالي", () => setState(() => _currentStep = 2)),
        ],
      ),
    );
  }

  // -------------------------- STEP 3 — Payment --------------------------
  Step stepPayment() {
    return Step(
      stepStyle: StepStyle(
        color: Colors.orange,
        connectorColor: Colors.blue,
      ),
      title: const Text("الدفع"),
      isActive: _currentStep >= 2,
      state: StepState.editing,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("اختر طريقة الدفع المناسبة:",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 5),
          Text(
            "طريقة الدفع المتوفرة حاليًا هي محفظة جيب فقط",
            style: TextStyle(color: Colors.orange[700]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                paymentOption(Colors.deepOrange, "محفظة جيب",
                    Icons.account_balance_wallet,
                    isJeeb: true),
                paymentOption(
                    Colors.lightBlue, "PayPal", Icons.paypal_outlined),
                paymentOption(Colors.orange, "Visa", Icons.credit_card),
              ],
            ),
          ),
          const SizedBox(height: 20),
          borderedField(walletNumberCtrl, "أدخل رقمك في تطبيق جيب"),
          const SizedBox(height: 25),
          orangeButton("تأكيد الطلب", () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return SuccessPage();
              },
            ));
          }),
        ],
      ),
    );
  }

  // -------------------------- TextField with orange border --------------------------
  Widget borderedField(TextEditingController ctrl, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // -------------------------- Orange button --------------------------
  Widget orangeButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child:
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  // -------------------------- Payment Option --------------------------
  Widget paymentOption(Color color, String label, IconData icon,
      {bool isJeeb = false}) {
    return GestureDetector(
      onTap: () async {
        setState(() => selectedPayment = label);
        if (isJeeb) {
          final url = Uri.parse("jeeb://open");
          await launchUrl(url);
          walletNumberCtrl.text = "55311220"; // مثال
        }
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          border: Border.all(
              color: selectedPayment == label
                  ? Colors.orange
                  : Colors.white.withOpacity(0.3),
              width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Scalloped Circle with check mark
            Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(200, 200),
                  painter: _ScallopedCirclePainter(
                    radius: 100,
                    scallops: 44,
                    color: Colors.orangeAccent, // circle color
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 80,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Successful Paid",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Paid number: 2023987239849",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: EdgeInsets.only(top: 160),
                  color: Colors.orange,
                  child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(context, "/home");
                      },
                      text: "Done"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Scalloped Circle Painter ----------------
class _ScallopedCirclePainter extends CustomPainter {
  final double radius;
  final int scallops;
  final Color color;

  _ScallopedCirclePainter(
      {required this.radius, required this.scallops, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    for (int i = 0; i <= scallops; i++) {
      double angle = (2 * pi / scallops) * i;
      double r = (i % 2 == 0) ? radius : radius - 15; // alternate small dips
      double x = centerX + r * cos(angle);
      double y = centerY + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
