import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ExpertLocationMapWidget extends StatelessWidget {
  final String locationName;
  const ExpertLocationMapWidget({super.key, required this.locationName});

  @override
  Widget build(BuildContext context) {
    final c = _coords[locationName];
    if (c == null) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(Icons.map_outlined, color: AppColors.primary, size: 18),
        const SizedBox(width: 6),
        const Text('موقع المهندس',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ]),
      const SizedBox(height: 8),
      ClipRRect(borderRadius: BorderRadius.circular(12),
        child: SizedBox(height: 160, child: GoogleMap(
          initialCameraPosition: CameraPosition(target: c, zoom: 12),
          markers: {Marker(markerId: const MarkerId('e'), position: c,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange))},
          zoomControlsEnabled: false, scrollGesturesEnabled: false,
          tiltGesturesEnabled: false, rotateGesturesEnabled: false,
          liteModeEnabled: true,
        ))),
    ]);
  }

  static const _coords = {
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
