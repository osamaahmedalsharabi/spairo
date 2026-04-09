import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_search_bar_widget.dart';
import 'map_confirm_button_widget.dart';

class ProfileMapPickerView extends StatefulWidget {
  final String? initialLocation;
  const ProfileMapPickerView({super.key, this.initialLocation});
  @override
  State<ProfileMapPickerView> createState() => _S();
}

class _S extends State<ProfileMapPickerView> {
  var _sel = const LatLng(15.3694, 44.1910);
  String _addr = '';
  GoogleMapController? _mc;
  @override
  void initState() { super.initState(); _addr = widget.initialLocation ?? ''; }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('اختر موقعك',
        style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
    body: Stack(children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(target: _sel, zoom: 12),
        onMapCreated: (c) => _mc = c,
        onTap: (p) => setState(() { _sel = p; _addr = _near(p); }),
        markers: {Marker(markerId: const MarkerId('l'), position: _sel,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange))},
      ),
      MapSearchBarWidget(onCitySelected: (n, p) {
        setState(() { _sel = p; _addr = n; });
        _mc?.animateCamera(CameraUpdate.newLatLngZoom(p, 13));
      }),
      Positioned(bottom: 24, left: 24, right: 24,
        child: MapConfirmButtonWidget(address: _addr,
          onConfirm: () => Navigator.pop(context, _addr))),
    ]),
  );

  String _near(LatLng p) {
    final c = MapSearchBarWidget.yemenCities;
    String n = c.keys.first; double md = double.infinity;
    for (final e in c.entries) {
      final d = (p.latitude - e.value.latitude) * (p.latitude - e.value.latitude)
          + (p.longitude - e.value.longitude) * (p.longitude - e.value.longitude);
      if (d < md) { md = d; n = e.key; }
    }
    return n;
  }
}
