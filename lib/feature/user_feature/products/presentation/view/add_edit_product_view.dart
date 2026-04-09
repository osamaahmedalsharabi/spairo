import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../../../../../Core/di/injection_container.dart';
import '../../../../Authantication/data/datasources/auth_local_data_source.dart';
import '../../../home/data/models/brand_model.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/presentation/view_model/get_brand_cars/get_brand_cars_cubit.dart';
import '../../../home/presentation/view_model/get_brands/get_brands_cubit.dart';
import '../../../home/presentation/view_model/get_categories/get_categories_cubit.dart';
import '../../../part_order/presentation/view/widgets/add_image_button_widget.dart';
import '../../../part_order/presentation/view/widgets/brand_selection_bottom_sheet.dart';
import '../../../part_order/presentation/view/widgets/car_selection_bottom_sheet.dart';
import '../../../part_order/presentation/view/widgets/category_selection_bottom_sheet.dart';
import '../../../part_order/presentation/view/widgets/custom_selector_widget.dart';
import '../../../part_order/presentation/view/widgets/dropdown_label_widget.dart';
import '../../../part_order/presentation/view/widgets/part_order_text_field.dart';
import '../../../part_order/presentation/view/widgets/submit_order_button_widget.dart';

import '../../domain/entities/product_entity.dart';
import '../view_model/manage_product_cubit.dart';
import '../view_model/manage_product_state.dart';

class AddOrEditProductView extends StatelessWidget {
  final ProductEntity? product;

  const AddOrEditProductView({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl.get<ManageProductCubit>()),
        // These might require setup if not already globally provided, assuming they are available or setting up similar to PartOrder
        BlocProvider(
          create: (context) => sl.get<GetBrandsCubit>()..getBrands(),
        ),
        BlocProvider(
          create: (context) => sl.get<GetCategoriesCubit>()..getCategories(),
        ),
        BlocProvider(create: (context) => sl.get<GetBrandCarsCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            product == null ? "إضافة منتج جديد" : "تعديل المنتج",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _ProductForm(product: product),
          ),
        ),
      ),
    );
  }
}

class _ProductForm extends StatefulWidget {
  final ProductEntity? product;
  const _ProductForm({this.product});

  @override
  State<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<_ProductForm> {
  BrandModel? selectedBrand;
  BrandModel? selectedCar;
  CategoryModel? selectedCategory;
  String? selectedYear;
  String? selectedCondition;
  File? selectedImage;
  String? currentImageUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final List<String> conditions = ["جديد", "مستعمل"];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      final p = widget.product!;
      nameController.text = p.name;
      detailsController.text = p.description;
      priceController.text = p.price.toString();
      quantityController.text = p.quantity.toString();
      selectedYear = p.modelYear;
      selectedCondition = p.condition;
      currentImageUrl = p.image;

      // Note: Full BrandModel/CarModel reconstruction is complex without full list.
      // A simplified approach uses mock ones just for display name, or matching from lists later.
      selectedBrand = BrandModel(id: '', name: p.brandName, image: '');
      selectedCar = BrandModel(id: '', name: p.carName, image: '');
      selectedCategory = CategoryModel(name: p.categoryName, image: '');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    priceController.dispose();
    quantityController.dispose();
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
            selectedCar = null;
            context.read<GetBrandCarsCubit>().getBrandCars(val.id);
          });
        }
      });
    }
  }

  void _showCarsBottomSheet() {
    if (selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار الشركة أولاً')));
      return;
    }

    if (selectedBrand!.id.isEmpty) {
      final bState = context.read<GetBrandsCubit>().state;
      if (bState is GetBrandsSuccess) {
         try {
           final realBrand = bState.brands.firstWhere((b) => b.name == selectedBrand!.name);
           selectedBrand = realBrand;
           context.read<GetBrandCarsCubit>().getBrandCars(realBrand.id);
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري جلب سيارات الشركة، حاول النقر مجدداً بعد ثانية')));
           return;
         } catch(e) {}
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى إعادة اختيار الشركة من القائمة أولاً')));
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
    } else {
      context.read<GetBrandCarsCubit>().getBrandCars(selectedBrand!.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري التحميل، حاول مجدداً')));
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
      builder: (ctx) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(items[index]),
          onTap: () {
            onSelect(items[index]);
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  void _showYearPickerDialog() {
    int initialYear = selectedYear != null
        ? int.parse(selectedYear!)
        : DateTime.now().year;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              setState(() => selectedYear = dateTime.year.toString());
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (selectedBrand == null ||
        selectedCar == null ||
        selectedCategory == null ||
        selectedYear == null ||
        selectedCondition == null ||
        nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تعبئة جميع الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.product == null && selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار صورة المنتج'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = await sl.get<AuthLocalDataSource>().getUser();
    if (user == null) return;

    final price = double.tryParse(priceController.text) ?? 0.0;
    final quantity = int.tryParse(quantityController.text) ?? 0;

    final productEntity = ProductEntity(
      id: widget.product?.id ?? '',
      supplierId: user.id,
      name: nameController.text,
      description: detailsController.text,
      price: price,
      quantity: quantity,
      brandName: selectedBrand!.name,
      carName: selectedCar!.name,
      categoryName: selectedCategory!.name,
      modelYear: selectedYear!,
      condition: selectedCondition!,
      image: currentImageUrl ?? '',
      localImage: selectedImage,
      isApproved: widget.product?.isApproved ?? false,
    );

    if (widget.product == null) {
      context.read<ManageProductCubit>().addProduct(productEntity);
    } else {
      context.read<ManageProductCubit>().updateProduct(productEntity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageProductCubit, ManageProductState>(
      listener: (context, state) {
        if (state is ManageProductSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back after success
        } else if (state is ManageProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state is ManageProductLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),

              const DropdownLabelWidget(label: "اسم المنتج"),
              PartOrderTextField(
                hint: "مثال: رديتر ماء دنسو",
                controller: nameController,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DropdownLabelWidget(label: "السعر (ر.س)"),
                        PartOrderTextField(
                          hint: "مثال: 150",
                          controller: priceController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DropdownLabelWidget(label: "الكمية المتوفرة"),
                        PartOrderTextField(
                          hint: "مثال: 5",
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const DropdownLabelWidget(label: "شركة السيارة المتوافقة"),
              CustomSelectorWidget(
                hint: "اختر الشركة",
                value: selectedBrand?.name,
                onTap: _showBrandsBottomSheet,
              ),
              const SizedBox(height: 16),

              const DropdownLabelWidget(label: "اسم السيارة المتوافقة"),
              CustomSelectorWidget(
                hint: "اختر السيارة",
                value: selectedCar?.name,
                onTap: _showCarsBottomSheet,
              ),
              const SizedBox(height: 16),

              const DropdownLabelWidget(label: "نوع القطعة"),
              CustomSelectorWidget(
                hint: "اختر نوع القطعة",
                value: selectedCategory?.name,
                onTap: _showCategoriesBottomSheet,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DropdownLabelWidget(label: "موديل السيارة"),
                        CustomSelectorWidget(
                          hint: "اختر الموديل",
                          value: selectedYear,
                          onTap: _showYearPickerDialog,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const DropdownLabelWidget(label: "وصف إضافي (اختياري)"),
              PartOrderTextField(
                hint: "اكتب وصفاً أو ملاحظات عن المنتج",
                controller: detailsController,
                maxLines: 3,
              ),
              const SizedBox(height: 22),

              AddImageButtonWidget(
                selectedImage: selectedImage,
                onTap: () async {
                  final file = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (file != null)
                    setState(() => selectedImage = File(file.path));
                },
              ),

              if (currentImageUrl != null &&
                  currentImageUrl!.isNotEmpty &&
                  selectedImage == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        currentImageUrl!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              SubmitOrderButtonWidget(
                onTap: (state is ManageProductLoading) ? () {} : _submitForm,
              ),
            ],
          ),
        );
      },
    );
  }
}
