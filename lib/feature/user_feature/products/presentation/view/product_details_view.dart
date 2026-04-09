import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/Widgets/custom_alert_dialog_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/feature/Authantication/presentation/cubit/get_user_data/get_user_data_cubit.dart';
import 'package:sparioapp/feature/Authantication/presentation/cubit/get_user_data/get_user_data_state.dart';
import '../../domain/entities/product_entity.dart';
import '../view_model/manage_product_cubit.dart';
import '../view_model/manage_product_state.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/submit_order_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsView({super.key, required this.product});

  void _confirmDelete(BuildContext context) {
    CustomAlertDialogWidget.show(
      context: context,
      title: "تأكيد الحذف",
      content:
          "هل أنت متأكد من حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.",
      onPrimaryPressed: () {
        context.read<ManageProductCubit>().deleteProduct(product.id);
        Navigator.pop(context); // close dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl.get<ManageProductCubit>()),
        BlocProvider(
          create: (context) =>
              sl.get<GetUserDataCubit>()..getUserData(product.supplierId),
        ),
        BlocProvider(create: (context) => sl.get<SubmitOrderCubit>()),
      ],
      child: BlocConsumer<ManageProductCubit, ManageProductState>(
        listener: (context, state) {
          if (state is ManageProductSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.pop(); // Go back
          } else if (state is ManageProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return BlocListener<SubmitOrderCubit, SubmitOrderState>(
            listener: (context, submitState) {
              if (submitState is SubmitOrderLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (submitState is SubmitOrderSuccess) {
                Navigator.pop(context); // close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال الطلب بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (submitState is SubmitOrderFailure) {
                Navigator.pop(context); // close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(submitState.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context, state),
                  SliverToBoxAdapter(
                    child: Container(
                      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                      decoration: const BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            _buildHeaderAndPrice(),
                            const SizedBox(height: 20),
                            _buildBadgesRow(),
                            const SizedBox(height: 24),
                            _buildQuantityCard(),
                            const SizedBox(height: 24),
                            _buildSectionTitle("وصف المنتج"),
                            const SizedBox(height: 12),
                            _buildDescription(),
                            const SizedBox(height: 32),
                            _buildSectionTitle("معلومات المورد"),
                            const SizedBox(height: 16),
                            _buildSupplierCard(),
                            const SizedBox(height: 32),
                            _buildActionButtons(context),
                            const SizedBox(
                              height: 100,
                            ), // padding for bottom scrolling
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ManageProductState state) {
    final bool isOwner =
        FirebaseAuth.instance.currentUser?.uid == product.supplierId;

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withAlpha(200),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      actions: [
        if (state is! ManageProductLoading && isOwner) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withAlpha(200),
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: () {
                  context
                      .pushNamed(AppRouteConst.addEditProduct, extra: product)
                      .then((_) => context.pop());
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withAlpha(200),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => _confirmDelete(context),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (state is ManageProductLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            product.image.isNotEmpty
                ? Hero(
                    tag: product.id,
                    child: Image.network(product.image, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
            // Gradient Overlay to ensure text/icons are visible
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "${product.price} ر.س",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildChip(Icons.business, product.brandName),
        _buildChip(Icons.directions_car, product.carName),
        _buildChip(Icons.category, product.categoryName),
        _buildChip(Icons.calendar_today, product.modelYear),
        _buildChip(Icons.star_border, product.condition),
      ],
    );
  }

  Widget _buildChip(IconData icon, String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityCard() {
    final bool isAvailable = product.quantity > 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAvailable ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAvailable ? Icons.check_circle_outline : Icons.error_outline,
              color: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAvailable ? "المنتج متوفر" : "نفذت الكمية",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isAvailable
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                if (isAvailable) ...[
                  const SizedBox(height: 2),
                  Text(
                    "الكمية المتاحة: ${product.quantity}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      product.description.isEmpty
          ? "لا يوجد وصف إضافي لهذا المنتج."
          : product.description,
      style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.6),
    );
  }

  Widget _buildSupplierCard() {
    return BlocBuilder<GetUserDataCubit, GetUserDataState>(
      builder: (context, userState) {
        if (userState is GetUserDataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (userState is GetUserDataSuccess) {
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                AppRouteConst.filteredProductsView,
                extra: {
                  'title': 'منتجات ${userState.user.name}',
                  'filterType': 'supplier',
                  'filterValue': product.supplierId,
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(
                          Icons.storefront,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userState.user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "بائع موثوق",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  _buildContactRow(Icons.phone_outlined, userState.user.phone),
                  // if (userState.user.email.isNotEmpty) ...[
                  //   const SizedBox(height: 12),
                  //   _buildContactRow(
                  //     Icons.email_outlined,
                  //     userState.user.email,
                  //   ),
                  // ],
                ],
              ),
            ),
          );
        } else if (userState is GetUserDataFailure) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "فشل في تحميل بيانات المورد.",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.red),
                  onPressed: () {
                    context.read<GetUserDataCubit>().getUserData(
                      product.supplierId,
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContactRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(
                    AppRouteConst.priceComparisonView,
                    extra: product,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
                child: const Text(
                  "مقارنة الأسعار",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(
                    AppRouteConst.filteredProductsView,
                    extra: {
                      'title': 'قطع متوافقة',
                      'filterType': 'compatible',
                      'carName': product.carName,
                      'year': product.modelYear,
                      'excludeProductId': product.id,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundLight,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
                child: const Text(
                  "قطع متوافقة",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("يجب تسجيل الدخول أولاً"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (uid == product.supplierId) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("لا يمكنك طلب منتجك الخاص"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // Fetch sender type for order tracking
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get();
              final senderType = userDoc.data()?['userType'] ?? 'مستخدم';

              if (userDoc["is_active"] == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("يجب تفعيل الحساب أولاً"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              final order = PartOrderModel(
                uid: uid,
                orderNumber:
                    'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                status: OrderStatus.pending,
                companyName: product.brandName,
                companyImage: '',
                carName: product.carName,
                carImage: '',
                categoryName: product.categoryName,
                categoryImage: '',
                carYear: product.modelYear,
                condition: product.condition,
                partNumber: '',
                partName: product.name,
                details: product.description,
                orderImage: product.image,
                createdAt: DateTime.now(),
                supplierId: product.supplierId,
                productId: product.id,
                productPrice: product.price,
                senderType: senderType,
              );

              context.pushNamed(AppRouteConst.checkout, extra: order);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "طلب القطعة",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
