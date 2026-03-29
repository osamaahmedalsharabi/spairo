import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

void showContactManagementBottomSheet(BuildContext context) {
  const String phoneNumberForCall = '+967779419803';
  const String phoneNumberForWhatsapp = '967779419803';

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'تواصل مع الإدارة',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              const Text(
                'اختر وسيلة التواصل المناسبة لك:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.phone, color: AppColors.primary),
                title: const Text('اتصال هاتفي'),
                onTap: () async {
                  final Uri url = Uri(scheme: 'tel', path: phoneNumberForCall);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              ListTile(
                leading: SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png?_=20200503174721",
                  ),
                ),
                title: const Text('واتساب'),
                onTap: () async {
                  final Uri url = Uri.parse(
                    'https://wa.me/$phoneNumberForWhatsapp',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
