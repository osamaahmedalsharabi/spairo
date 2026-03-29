import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/brand_model.dart';
import 'package:sparioapp/feature/user_feature/home/data/models/category_model.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brands/get_brands_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_categories/get_categories_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brand_cars/get_brand_cars_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_brand_card.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/home_category_card.dart';

import '../view_model/search_products_cubit/search_products_cubit.dart';
import '../view_model/search_products_cubit/search_products_state.dart';
import 'widgets/product_card_widget.dart';

class SearchProductsView extends StatefulWidget {
  final String? initialQuery;
  final List<String>? initialIds;
  const SearchProductsView({super.key, this.initialQuery, this.initialIds});

  @override
  State<SearchProductsView> createState() => _SearchProductsViewState();
}

class _SearchProductsViewState extends State<SearchProductsView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialIds != null && widget.initialIds!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SearchProductsCubit>().searchProductsByIds(widget.initialIds!, widget.initialQuery ?? '');
      });
    } else if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SearchProductsCubit>().searchProduct(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (value) {
                          context.read<SearchProductsCubit>().searchProduct(
                            value,
                          );
                          setState(
                            () {},
                          ); // to update the local clear button visibility
                        },
                        decoration: InputDecoration(
                          hintText: 'ابحث عن قطع غيار...',
                          hintStyle: const TextStyle(fontSize: 14),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    context
                                        .read<SearchProductsCubit>()
                                        .searchProduct('');
                                    setState(() {});
                                  },
                                ),
                              IconButton(
                                icon: const Icon(
                                  Icons.tune,
                                  color: AppColors.primary,
                                ),
                                onPressed: () =>
                                    _showFilterBottomSheet(context),
                              ),
                            ],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchProductsCubit, SearchProductsState>(
                builder: (context, state) {
                  if (state is SearchProductsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (state is SearchProductsSuccess) {
                    if (state.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لم يتم العثور على أية منتجات مطابقة',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return ProductCardWidget(
                          product: state.products[index],
                          onTap: () {
                            context.pushNamed(
                              AppRouteConst.productDetails,
                              extra: state.products[index],
                            );
                          },
                        );
                      },
                    );
                  } else if (state is SearchProductsFailure) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext parentContext) {
    final cubit = parentContext.read<SearchProductsCubit>();
    final getBrandsCubit = parentContext.read<GetBrandsCubit>();
    final getBrandCarsCubit = parentContext.read<GetBrandCarsCubit>();
    final getCategoriesCubit = parentContext.read<GetCategoriesCubit>();

    String? tempBrand = cubit.selectedBrand;
    String? tempCar = cubit.selectedCar;
    String? tempCategory = cubit.selectedCategory;
    String? tempCondition = cubit.selectedCondition;
    String? tempYear = cubit.selectedYear;

    double absoluteMax = cubit.absoluteMaxPrice;
    if (absoluteMax < 100) absoluteMax = 100.0;

    double currentMinPrice = cubit.minPrice ?? 0.0;
    double currentMaxPrice = cubit.maxPrice ?? absoluteMax;
    if (currentMaxPrice > absoluteMax) currentMaxPrice = absoluteMax;
    if (currentMinPrice < 0) currentMinPrice = 0.0;

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getBrandsCubit),
            BlocProvider.value(value: getBrandCarsCubit),
            BlocProvider.value(value: getCategoriesCubit),
          ],
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "فلترة النتائج",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // BRANDS
                      BlocBuilder<GetBrandsCubit, GetBrandsState>(
                        builder: (context, state) {
                          if (state is GetBrandsLoading) {
                            return const Center(child: SizedBox());
                          }
                          if (state is GetBrandsSuccess) {
                            return _buildCardFilterSection<BrandModel>(
                              "البراند",
                              state.brands,
                              tempBrand,
                              (b) => b.name,
                              (
                                BrandModel item,
                                bool isSelected,
                                VoidCallback emptyOnTap,
                              ) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: HomeBrandCard(
                                    brand: item,
                                    onTapOverride: () {
                                      setState(() {
                                        if (tempBrand == item.name) {
                                          tempBrand = null;
                                          tempCar = null;
                                        } else {
                                          tempBrand = item.name;
                                          tempCar = null;
                                          context
                                              .read<GetBrandCarsCubit>()
                                              .getBrandCars(item.id);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),

                      // CARS
                      if (tempBrand != null)
                        BlocBuilder<GetBrandCarsCubit, GetBrandCarsState>(
                          builder: (context, state) {
                            if (state is GetBrandCarsLoading) {
                              return const Center(child: SizedBox());
                            }
                            if (state is GetBrandCarsSuccess) {
                              return _buildCardFilterSection<BrandModel>(
                                "نوع السيارة",
                                state.cars,
                                tempCar,
                                (c) => c.name,
                                (
                                  BrandModel item,
                                  bool isSelected,
                                  VoidCallback emptyOnTap,
                                ) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: HomeBrandCard(
                                      brand: item,
                                      onTapOverride: () {
                                        setState(() {
                                          tempCar = tempCar == item.name
                                              ? null
                                              : item.name;
                                        });
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                            return const SizedBox();
                          },
                        ),

                      // MODEL YEAR
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          "سنة الصنع",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          int initialYear = tempYear != null
                              ? int.tryParse(tempYear!) ?? DateTime.now().year
                              : DateTime.now().year;
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text(
                                  "اختر موديل السيارة",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
                                        tempYear = dateTime.year.toString();
                                      });
                                      Navigator.pop(dialogContext);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tempYear ?? "اختر سنة الصنع",
                                style: TextStyle(
                                  color: tempYear == null
                                      ? Colors.grey
                                      : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              if (tempYear != null)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      tempYear = null;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),

                      // CATEGORIES
                      BlocBuilder<GetCategoriesCubit, GetCategoriesState>(
                        builder: (context, state) {
                          if (state is GetCategoriesLoading) {
                            return const Center(child: SizedBox());
                          }
                          if (state is GetCategoriesSuccess) {
                            return _buildCardFilterSection<CategoryModel>(
                              "الصنف",
                              state.categories,
                              tempCategory,
                              (c) => c.name,
                              (
                                CategoryModel item,
                                bool isSelected,
                                VoidCallback emptyOnTap,
                              ) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: HomeCategoryCard(
                                    category: item,
                                    onTapOverride: () {
                                      setState(() {
                                        tempCategory = tempCategory == item.name
                                            ? null
                                            : item.name;
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),

                      // // PRICE RANGE
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     const Padding(
                      //       padding: EdgeInsets.symmetric(vertical: 12.0),
                      //       child: Text(
                      //         "نطاق السعر",
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     ),
                      //     RangeSlider(
                      //       min: 0,
                      //       max: absoluteMax,
                      //       divisions: 100,
                      //       values: RangeValues(
                      //         currentMinPrice,
                      //         currentMaxPrice,
                      //       ),
                      //       activeColor: AppColors.primary,
                      //       labels: RangeLabels(
                      //         "${currentMinPrice.toInt()} ر.س",
                      //         "${currentMaxPrice.toInt()} ر.س",
                      //       ),
                      //       onChanged: (RangeValues values) {
                      //         setState(() {
                      //           currentMinPrice = values.start;
                      //           currentMaxPrice = values.end;
                      //         });
                      //       },
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //         horizontal: 16.0,
                      //       ),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             "${currentMinPrice.toInt()} ر.س",
                      //             style: TextStyle(color: Colors.grey.shade700),
                      //           ),
                      //           Text(
                      //             "${currentMaxPrice.toInt()} ر.س",
                      //             style: TextStyle(color: Colors.grey.shade700),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     const SizedBox(height: 8),
                      //     const Divider(height: 1),
                      //   ],
                      // ),

                      // CONDITIONS (Static via chip builder)
                      _buildChipFilterSection(
                        "حالة المنتج",
                        ["جديد", "مستعمل"],
                        tempCondition,
                        (String val) {
                          setState(() {
                            tempCondition = tempCondition == val ? null : val;
                          });
                        },
                      ),

                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                cubit.clearFilters();
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "مسح الفلاتر",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                cubit.applyFilters(
                                  brand: tempBrand,
                                  car: tempCar,
                                  category: tempCategory,
                                  condition: tempCondition,
                                  year: tempYear,
                                  min: currentMinPrice,
                                  max: currentMaxPrice,
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "تطبيق الفلترة",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCardFilterSection<T>(
    String title,
    List<T> items,
    String? selectedItemName,
    String Function(T) labelExtractor,
    Widget Function(T item, bool isSelected, VoidCallback emptyOnTap)
    cardBuilder,
  ) {
    if (items.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 120, // Tall enough for HomeBrandCard / HomeCategoryCard
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              final label = labelExtractor(item);
              final isSelected = selectedItemName == label;
              return Tooltip(
                message: label,
                child: cardBuilder(item, isSelected, () {}),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildChipFilterSection(
    String title,
    List<String> items,
    String? selectedValue,
    Function(String) onSelect,
  ) {
    if (items.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedValue == item;
            return ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (_) => onSelect(item),
              selectedColor: AppColors.primary.withOpacity(0.1),
              backgroundColor: AppColors.backgroundLight,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }
}
