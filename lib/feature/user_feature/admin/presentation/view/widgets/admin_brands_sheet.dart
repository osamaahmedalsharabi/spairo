import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import '../../view_model/admin_cubit.dart';
import 'admin_add_dialog.dart';

class AdminBrandsSheet extends StatelessWidget {
  final List<BrandModel> brands;
  final void Function(BrandModel brand) onBrandTap;

  const AdminBrandsSheet({
    super.key,
    required this.brands,
    required this.onBrandTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...brands.map((b) => _BrandTile(
            brand: b, onTap: () => onBrandTap(b))),
      const SizedBox(height: 12),
      _AddBrandButton(),
    ]);
  }
}

class _BrandTile extends StatelessWidget {
  final BrandModel brand;
  final VoidCallback onTap;
  const _BrandTile({
    required this.brand, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: brand.image.isNotEmpty
            ? CircleAvatar(
                backgroundImage:
                    NetworkImage(brand.image))
            : const CircleAvatar(
                child: Icon(Icons.directions_car)),
        title: Text(brand.name),
        trailing: const Icon(
            Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _AddBrandButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => AdminAddDialog(
          title: 'إضافة براند',
          onAdd: (name, image) => context
              .read<AdminCubit>()
              .addBrand(name, image),
        ),
      ),
      icon: const Icon(Icons.add),
      label: const Text('إضافة براند'),
    );
  }
}
