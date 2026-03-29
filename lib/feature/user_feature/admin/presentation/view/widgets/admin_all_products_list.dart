import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/products/domain/entities/product_entity.dart';
import '../../view_model/admin_cubit.dart';

class AdminAllProductsList extends StatelessWidget {
  final List<ProductEntity> products;
  const AdminAllProductsList({
    super.key, required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text('لا توجد منتجات',
            style: TextStyle(color: Colors.grey)),
      );
    }
    return Column(
      children: products
          .map((p) => _ProductApprovalTile(product: p))
          .toList(),
    );
  }
}

class _ProductApprovalTile extends StatelessWidget {
  final ProductEntity product;
  const _ProductApprovalTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _productImage(),
          const SizedBox(width: 12),
          _productInfo(),
          _approvalSwitch(context),
        ],
      ),
    );
  }

  Widget _productImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: product.image.isNotEmpty
          ? Image.network(product.image,
              width: 50, height: 50,
              fit: BoxFit.cover)
          : Container(
              width: 50, height: 50,
              color: Colors.grey[200],
              child: const Icon(Icons.image,
                  color: Colors.grey)),
    );
  }

  Widget _productInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(
            '${product.brandName} • ${product.categoryName}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          Text('${product.price} ر.س',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget _approvalSwitch(BuildContext context) {
    return Column(
      children: [
        Switch(
          value: product.isApproved,
          activeColor: Colors.green,
          onChanged: (val) {
            context.read<AdminCubit>()
                .toggleProductApproval(
                    product.id, val);
          },
        ),
        Text(
          product.isApproved ? 'مفعّل' : 'معطّل',
          style: TextStyle(
            fontSize: 10,
            color: product.isApproved
                ? Colors.green
                : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
