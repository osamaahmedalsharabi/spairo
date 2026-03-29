import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/Widgets/custom_alert_dialog_widget.dart';
import 'package:sparioapp/feature/Authantication/data/datasources/auth_local_data_source.dart';
import 'package:sparioapp/feature/user_feature/ai_image_search/presentation/view_model/ai_image_search_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/contact_management_bottom_sheet.dart';
import '../../../../../../Core/Theme/app_colors.dart';

class HomeSearchSection extends StatelessWidget {
  const HomeSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<AiImageSearchCubit>(),
      child: BlocListener<AiImageSearchCubit, AiImageSearchState>(
        listener: (context, state) {
          if (state is AiImageSearchLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text('جاري تحليل الصورة بالذكاء الاصطناعي...'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AiImageSearchFailure) {
            Navigator.of(context, rootNavigator: true).pop(); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AiImageSearchSuccess) {
            Navigator.of(context, rootNavigator: true).pop(); // Close dialog

            final query = [
              state.partName,
              state.partNumber,
            ].where((e) => e != null && e.isNotEmpty && e != 'null').join(' ');

            if (query.isNotEmpty || state.matchedProductIds.isNotEmpty) {
              context.pushNamed(
                AppRouteConst.searchProducts,
                extra: { 'query': query, 'matchedIds': state.matchedProductIds },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم التعرف على قطعة ولكن لم نتمكن من استخراج تفاصيل كافية للبحث عنها.',
                  ),
                ),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(80),
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
                    readOnly: true,
                    onTap: () {
                      context.pushNamed(AppRouteConst.searchProducts);
                    },
                    decoration: const InputDecoration(
                      hintText: 'ابحث عن قطع غيار...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      suffixIcon: Icon(Icons.tune, color: AppColors.primary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Builder(
                // Builder is used here so context finds the BlocProvider
                builder: (context) {
                  return Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: AppColors.white,
                        ),
                        onPressed: () async {
                          final authLocalDS = sl.get<AuthLocalDataSource>();
                          final user = await authLocalDS.getUser();
                          if (user == null) {
                            CustomAlertDialogWidget.show(
                              context: context,
                              title: "تنبيه",
                              content: "يجب تسجيل الدخول للوصول إلى هذه الميزة",
                              primaryButtonText: "الغاء",
                              secondaryButtonText: "تسجيل الدخول",
                              icon: Icons.info_outline,
                              onSecondaryPressed: () {
                                Navigator.pop(context);
                                context.push("/login");
                              },
                            );
                          } else if (!user.isActive) {
                            CustomAlertDialogWidget.show(
                              context: context,
                              title: "تنبيه",
                              content:
                                  "سوف يتم مراجعة حسابك قريبا لكي تتمكن من استخدام الميزة او يمكنك التواصل مع إدارة التطبيق",
                              primaryButtonText: "حسنا",
                              secondaryButtonText: "تواصل مع الإدارة",
                              icon: Icons.info_outline,
                              onSecondaryPressed: () {
                                Navigator.pop(context);
                                showContactManagementBottomSheet(context);
                              },
                            );
                          } else {
                            final ImagePicker picker = ImagePicker();
                            // Modal bottom sheet to choose between camera and gallery
                            showModalBottomSheet(
                              context: context,
                              builder: (bottomSheetContext) {
                                return SafeArea(
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera_alt),
                                        title: const Text('التقاط صورة'),
                                        onTap: () async {
                                          Navigator.pop(bottomSheetContext);
                                          final XFile? photo = await picker
                                              .pickImage(
                                                source: ImageSource.camera,
                                              );
                                          if (photo != null) {
                                            if (context.mounted) {
                                              context
                                                  .read<AiImageSearchCubit>()
                                                  .analyzeImage(
                                                    File(photo.path),
                                                  );
                                            }
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.photo_library,
                                        ),
                                        title: const Text('اختيار من المعرض'),
                                        onTap: () async {
                                          Navigator.pop(bottomSheetContext);
                                          final XFile? image = await picker
                                              .pickImage(
                                                source: ImageSource.gallery,
                                              );
                                          if (image != null) {
                                            if (context.mounted) {
                                              context
                                                  .read<AiImageSearchCubit>()
                                                  .analyzeImage(
                                                    File(image.path),
                                                  );
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
