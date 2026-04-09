import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class MapSearchBarWidget extends StatelessWidget {
  final void Function(String city, LatLng pos) onCitySelected;
  const MapSearchBarWidget({super.key, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 16, left: 16, right: 16,
      child: Container(
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),
            blurRadius: 10, offset: const Offset(0, 2))]),
        child: PopupMenuButton<MapEntry<String, LatLng>>(
          offset: const Offset(0, 50),
          onSelected: (e) => onCitySelected(e.key, e.value),
          itemBuilder: (_) => yemenCities.entries
              .map((e) => PopupMenuItem(value: e,
                  child: Text(e.key, style: const TextStyle(fontSize: 14))))
              .toList(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Icon(Icons.search, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('ابحث عن مدينتك', style: TextStyle(color: Colors.grey)),
            ]),
          ),
        ),
      ),
    );
  }

  static const yemenCities = {
    'صنعاء': LatLng(15.3694, 44.1910),
    'عدن': LatLng(12.7855, 45.0187),
    'تعز': LatLng(13.5789, 44.0220),
    'الحديدة': LatLng(14.7980, 42.9540),
    'إب': LatLng(13.9664, 44.1747),
    'ذمار': LatLng(14.5426, 44.4050),
    'مأرب': LatLng(15.4542, 45.3268),
    'حضرموت': LatLng(15.9539, 48.7919),
    'المكلا': LatLng(14.5427, 49.1281),
  };
}
