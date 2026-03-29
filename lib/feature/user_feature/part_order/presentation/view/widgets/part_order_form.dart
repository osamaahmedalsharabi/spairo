import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brand_cars/get_brand_cars_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brands/get_brands_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_categories/get_categories_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/models/part_order_model.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/submit_order_cubit.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/feature/Authantication/data/datasources/auth_local_data_source.dart';

import 'add_image_button_widget.dart';
import 'brand_selection_bottom_sheet.dart';
import 'car_selection_bottom_sheet.dart';
import 'category_selection_bottom_sheet.dart';
import 'custom_selector_widget.dart';
import 'dropdown_label_widget.dart';
import 'part_order_text_field.dart';
import 'submit_order_button_widget.dart';

class PartOrderForm extends StatefulWidget {
  const PartOrderForm({super.key});

  @override
  State<PartOrderForm> createState() => _PartOrderFormState();
}

class _PartOrderFormState extends State<PartOrderForm> {
  BrandModel? selectedBrand;
  BrandModel? selectedCar;
  CategoryModel? selectedCategory;
  String? selectedYear;
  String? selectedCondition;
  File? selectedImage;

  final TextEditingController partNumberController = TextEditingController();
  final TextEditingController partNameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  final List<String> conditions = ["جديد", "مستعمل"];
  final List<String> years = List.generate(
    2025 - 1980 + 1,
    (i) => (1980 + i).toString(),
  );

  @override
  void dispose() {
    partNumberController.dispose();
    partNameController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  void _showBrandsBottomSheet() {
    final state = context.read<GetBrandsCubit>().state;
    if (state is GetBrandsSuccess) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => BrandSelectionBottomSheet(brands: state.brands),
      ).then((val) {
        if (val != null && val is BrandModel) {
          setState(() {
            selectedBrand = val;
            selectedCar = null; // Reset car when brand changes
            context.read<GetBrandCarsCubit>().getBrandCars(val.id);
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الانتظار حتى يتم تحميل الشركات')),
      );
    }
  }

  void _showCarsBottomSheet() {
    if (selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار الشركة أولاً')),
      );
      return;
    }
    final state = context.read<GetBrandCarsCubit>().state;
    if (state is GetBrandCarsSuccess) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => CarSelectionBottomSheet(cars: state.cars),
      ).then((val) {
        if (val != null && val is BrandModel) {
          setState(() => selectedCar = val);
        }
      });
    } else if (state is GetBrandCarsLoading) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('جاري تحميل السيارات...')));
    }
  }

  void _showCategoriesBottomSheet() {
    final state = context.read<GetCategoriesCubit>().state;
    if (state is GetCategoriesSuccess) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) =>
            CategorySelectionBottomSheet(categories: state.categories),
      ).then((val) {
        if (val != null && val is CategoryModel) {
          setState(() => selectedCategory = val);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الانتظار حتى يتم تحميل الأقسام')),
      );
    }
  }

  void _showSimpleBottomSheet(
    String title,
    List<String> items,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      builder: (ctx) {
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              onTap: () {
                onSelect(items[index]);
                Navigator.pop(ctx);
              },
            );
          },
        );
      },
    );
  }

  void _showYearPickerDialog() {
    int initialYear = selectedYear != null
        ? int.parse(selectedYear!)
        : DateTime.now().year;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("اختر موديل السيارة"),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1980),
              lastDate: DateTime(DateTime.now().year + 2),
              selectedDate: DateTime(initialYear),
              onChanged: (DateTime dateTime) {
                setState(() {
                  selectedYear = dateTime.year.toString();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DropdownLabelWidget(label: "شركة السيارة"),
          CustomSelectorWidget(
            hint: "اختر الشركة",
            value: selectedBrand?.name,
            onTap: _showBrandsBottomSheet,
          ),
          const SizedBox(height: 16),

          const DropdownLabelWidget(label: "اسم السيارة"),
          CustomSelectorWidget(
            hint: "اختر السيارة",
            value: selectedCar?.name,
            onTap: _showCarsBottomSheet,
          ),
          const SizedBox(height: 16),

          const DropdownLabelWidget(label: "نوع قطعة الغيار"),
          CustomSelectorWidget(
            hint: "اختر نوع قطعة",
            value: selectedCategory?.name,
            onTap: _showCategoriesBottomSheet,
          ),
          const SizedBox(height: 16),

          const DropdownLabelWidget(label: "موديل السيارة"),
          CustomSelectorWidget(
            hint: "اختر الموديل",
            value: selectedYear,
            onTap: _showYearPickerDialog,
          ),
          const SizedBox(height: 16),

          const DropdownLabelWidget(label: "حالة القطعة"),
          CustomSelectorWidget(
            hint: "اختر الحالة",
            value: selectedCondition,
            onTap: () => _showSimpleBottomSheet(
              "اختر الحالة",
              conditions,
              (v) => setState(() => selectedCondition = v),
            ),
          ),
          const SizedBox(height: 16),

          const DropdownLabelWidget(label: "رقم قطعة السيارة (إن وجد)"),
          PartOrderTextField(
            hint: "أدخل رقم القطعة",
            controller: partNumberController,
          ),
          const SizedBox(height: 16),

          const DropdownLabelWidget(label: "اسم قطعة السيارة"),
          PartOrderTextField(
            hint: "مثال: لمبة أمامية",
            controller: partNameController,
          ),
          const SizedBox(height: 16),

          const DropdownLabelWidget(label: "تفاصيل قطعة السيارة (إن وجد)"),
          PartOrderTextField(
            hint: "اكتب وصفًا للقطعة",
            controller: detailsController,
            maxLines: 4,
          ),
          const SizedBox(height: 22),

          AddImageButtonWidget(
            selectedImage: selectedImage,
            onTap: () async {
              final file = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (file != null) {
                setState(() => selectedImage = File(file.path));
              }
            },
          ),
          const SizedBox(height: 22),

          SubmitOrderButtonWidget(
            onTap: () async {
              if (selectedBrand == null ||
                  selectedCar == null ||
                  selectedCategory == null ||
                  selectedYear == null ||
                  selectedCondition == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرجاء تعبئة جميع الحقول المطلوبة'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final authLocalDS = sl.get<AuthLocalDataSource>();
              final user = await authLocalDS.getUser();
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('الرجاء تسجيل الدخول أولاً'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final order = PartOrderModel(
                uid: user.id,
                orderNumber:
                    '#${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                status: OrderStatus.pending,
                companyName: selectedBrand!.name,
                companyImage: selectedBrand!.image,
                carName: selectedCar!.name,
                carImage: selectedCar!.image,
                categoryName: selectedCategory!.name,
                categoryImage: selectedCategory!.image,
                carYear: selectedYear!,
                condition: selectedCondition!,
                partNumber: partNumberController.text,
                partName: partNameController.text,
                details: detailsController.text,
                createdAt: DateTime.now(),
              );

              context.read<SubmitOrderCubit>().submitOrder(
                order,
                selectedImage,
              );
            },
          ),
        ],
      ),
    );
  }
}
