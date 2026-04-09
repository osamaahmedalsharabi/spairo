import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ProfileEditLocationDialog extends StatefulWidget {
  final String currentLocation;
  final Function(String) onSave;

  const ProfileEditLocationDialog({
    super.key,
    required this.currentLocation,
    required this.onSave,
  });

  @override
  State<ProfileEditLocationDialog> createState() =>
      _ProfileEditLocationDialogState();
}

class _ProfileEditLocationDialogState extends State<ProfileEditLocationDialog> {
  late String selectedCity;
  // TODO: Fetch this from a proper source or constant if needed.
  final List<String> cities = [
    'صنعاء',
    'عدن',
    'تعز',
    'الحديدة',
    'إب',
    'ذمار',
    'حضرموت',
    'شبوة',
    'مأرب',
    'المهرة',
    'سقطرى',
    'أبين',
    'لحج',
    'الضالع',
    'البيضاء',
    'حجة',
    'المحويت',
    'صعدة',
    'عمران',
    'الجوف',
    'ريمة',
  ];

  @override
  void initState() {
    super.initState();
    selectedCity = cities.contains(widget.currentLocation)
        ? widget.currentLocation
        : cities.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'تعديل الموقع',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: DropdownButtonFormField<String>(
        value: selectedCity,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        items: cities.map((city) {
          return DropdownMenuItem(value: city, child: Text(city));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedCity = value;
            });
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            widget.onSave(selectedCity);
            Navigator.pop(context);
          },
          child: const Text('حفظ', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
