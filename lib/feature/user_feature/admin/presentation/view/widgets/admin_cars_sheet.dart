import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import '../../view_model/admin_cubit.dart';
import 'admin_add_dialog.dart';

class AdminCarsSheet extends StatefulWidget {
  final BrandModel brand;
  const AdminCarsSheet({
    super.key, required this.brand,
  });

  @override
  State<AdminCarsSheet> createState() =>
      _AdminCarsSheetState();
}

class _AdminCarsSheetState
    extends State<AdminCarsSheet> {
  List<BrandModel> _cars = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final cars = await context
        .read<AdminCubit>()
        .getBrandCars(widget.brand.id);
    if (mounted) {
      setState(() {
        _cars = cars;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('سيارات ${widget.brand.name}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
      const SizedBox(height: 12),
      if (_loading)
        const CircularProgressIndicator()
      else ...[
        ..._cars.map((c) => _CarTile(car: c)),
        if (_cars.isEmpty)
          const Text('لا توجد سيارات',
              style: TextStyle(
                  color: Colors.grey)),
        const SizedBox(height: 12),
        _buildAddButton(context),
      ],
    ]);
  }

  Widget _buildAddButton(BuildContext ctx) {
    return ElevatedButton.icon(
      onPressed: () => showDialog(
        context: ctx,
        builder: (_) => AdminAddDialog(
          title: 'إضافة سيارة',
          onAdd: (name, image) {
            ctx.read<AdminCubit>().addCarToBrand(
                widget.brand.id, name, image);
            _loadCars();
          },
        ),
      ),
      icon: const Icon(Icons.add),
      label: const Text('إضافة سيارة'),
    );
  }
}

class _CarTile extends StatelessWidget {
  final BrandModel car;
  const _CarTile({required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: car.image.isNotEmpty
            ? CircleAvatar(
                backgroundImage:
                    NetworkImage(car.image))
            : const CircleAvatar(
                child: Icon(Icons.directions_car)),
        title: Text(car.name),
      ),
    );
  }
}
