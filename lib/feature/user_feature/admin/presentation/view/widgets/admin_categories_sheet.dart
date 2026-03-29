import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import '../../view_model/admin_cubit.dart';
import 'admin_add_dialog.dart';

class AdminCategoriesSheet extends StatelessWidget {
  final List<CategoryModel> categories;
  const AdminCategoriesSheet({
    super.key, required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...categories
          .map((c) => _CategoryTile(category: c)),
      if (categories.isEmpty)
        const Text('لا توجد أصناف',
            style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 12),
      _AddCategoryButton(),
    ]);
  }
}

class _CategoryTile extends StatelessWidget {
  final CategoryModel category;
  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: category.image.isNotEmpty
            ? CircleAvatar(
                backgroundImage:
                    NetworkImage(category.image))
            : const CircleAvatar(
                child: Icon(Icons.category)),
        title: Text(category.name),
      ),
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => AdminAddDialog(
          title: 'إضافة صنف',
          onAdd: (name, image) => context
              .read<AdminCubit>()
              .addCategory(name, image),
        ),
      ),
      icon: const Icon(Icons.add),
      label: const Text('إضافة صنف'),
    );
  }
}
