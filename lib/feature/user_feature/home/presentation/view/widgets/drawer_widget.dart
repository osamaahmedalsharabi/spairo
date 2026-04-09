import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/Authantication/presentation/cubit/auth_cubit.dart';
import 'package:sparioapp/feature/Authantication/presentation/cubit/auth_state.dart';
import 'package:sparioapp/Core/routing/app_route_const.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/contact_management_bottom_sheet.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view/widgets/drawer_list_tile_widget.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import 'package:sparioapp/Widgets/custom_alert_dialog_widget.dart';

import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';
import 'package:sparioapp/feature/Authantication/presentation/cubit/get_user_data/get_user_data_cubit.dart';
import 'package:sparioapp/feature/Authantication/presentation/cubit/get_user_data/get_user_data_state.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late GetUserDataCubit _getUserDataCubit;

  @override
  void initState() {
    super.initState();
    _getUserDataCubit = sl<GetUserDataCubit>();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessLogin) {
      _getUserDataCubit.getUserData(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          bool isLoggedIn = state is AuthSuccessLogin;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              if (isLoggedIn)
                BlocProvider.value(
                  value: _getUserDataCubit,
                  child: BlocBuilder<GetUserDataCubit, GetUserDataState>(
                    builder: (context, userState) {
                      late UserEntity displayUser;
                      if (userState is GetUserDataSuccess) {
                        displayUser = userState.user;
                      } else {
                        displayUser = state.user;
                      }

                      return Column(
                        children: [
                          DrawerHeader(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: AppColors.white.withAlpha(80),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: AppColors.primary
                                            .withOpacity(0.2),
                                        child: const Icon(
                                          Icons.person,
                                          size: 35,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              displayUser.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              displayUser.userType,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (!displayUser.isActive) {
                                            CustomAlertDialogWidget.show(
                                              context: context,
                                              title: "تنبيه",
                                              content:
                                                  "سوف يتم مراجعة حسابك قريبا لكي تتمكن من استخدام الميزة او يمكنك التواصل مع إدارة التطبيق",
                                              primaryButtonText: "حسنا",
                                              secondaryButtonText:
                                                  "تواصل مع الإدارة",
                                              icon: Icons.info_outline,
                                              onSecondaryPressed: () {
                                                showContactManagementBottomSheet(
                                                  context,
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: displayUser.isActive
                                                ? Colors.green.withAlpha(80)
                                                : Colors.red.withAlpha(80),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: displayUser.isActive
                                                  ? Colors.green
                                                  : Colors.red,
                                              style: BorderStyle.solid,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            displayUser.isActive
                                                ? " نشط"
                                                : " غير نشط",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          displayUser.email,
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        displayUser.phone,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "يجب تسجيل الدخول او إنشاء حساب جديد للوصول إلى جميع الميزات",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            context.pushNamed(AppRouteConst.login);

                            context.read<GetUserOrdersCubit>().getUserOrders();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFCA042),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (isLoggedIn)
                BlocProvider.value(
                  value: _getUserDataCubit,
                  child: BlocBuilder<GetUserDataCubit, GetUserDataState>(
                    builder: (context, userState) {
                      late UserEntity displayUser;
                      if (userState is GetUserDataSuccess) {
                        displayUser = userState.user;
                      } else {
                        displayUser = state.user;
                      }

                      return Column(
                        children: [
                          if (displayUser.userType == "مورد")
                            DrawerListTileWidget(
                              title: "المنتجات",
                              icon: Icons.card_giftcard,
                              onTap: () {
                                if (displayUser.isActive) {
                                  context.pushNamed(
                                    AppRouteConst.supplierProducts,
                                  );
                                } else {
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
                                }
                              },
                            ),
                          if (displayUser.userType == "مورد")
                            DrawerListTileWidget(
                              title: "الطلبات الواردة",
                              icon: Icons.inbox_rounded,
                              onTap: () {
                                if (displayUser.isActive) {
                                  Navigator.pop(context);
                                  context.pushNamed(
                                    AppRouteConst.supplierIncomingOrders,
                                  );
                                } else {
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
                                }
                              },
                            ),
                          if (displayUser.userType == "مورد")
                            DrawerListTileWidget(
                              title: "الطلبات المرسلة",
                              icon: Icons.outbox_rounded,
                              onTap: () {
                                if (displayUser.isActive) {
                                  Navigator.pop(context);
                                  context.pushNamed(
                                    AppRouteConst.supplierSentOrders,
                                  );
                                } else {
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
                                }
                              },
                            ),
                          if (displayUser.userType == "مورد")
                            DrawerListTileWidget(
                              title: "التقارير ",
                              icon: Icons.menu_book_rounded,
                              onTap: () {
                                if (displayUser.isActive) {
                                  context.pushNamed(
                                    AppRouteConst.supplierReport,
                                  );
                                } else {
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
                                }
                              },
                            ),
                          if (displayUser.userType == "مشرف")
                            DrawerListTileWidget(
                              title: "لوحة التحكم",
                              icon: Icons.admin_panel_settings,
                              onTap: () {
                                Navigator.pop(context);
                                context.pushNamed(AppRouteConst.adminDashboard);
                              },
                            ),
                          DrawerListTileWidget(
                            title: "الملف الشخصي ",
                            icon: Icons.person,
                            onTap: () {
                              Navigator.pop(context);
                              context.pushNamed(
                                AppRouteConst.profile,
                                extra: displayUser,
                              );
                            },
                          ),

                          DrawerListTileWidget(
                            title: 'مشاركة التطبيق',
                            icon: Icons.share,
                            onTap: () {
                              Navigator.pop(context);
                              Share.share(
                                'حمّل تطبيق Spairo لأفضل تجربة في عالم قطع غيار السيارات!\n\nhttps://play.google.com/store/apps/details?id=com.spairo.app',
                              );
                            },
                          ),
                          DrawerListTileWidget(
                            title: 'معلومات عن التطبيق',
                            icon: Icons.info,
                            onTap: () {
                              Navigator.pop(context);
                              showAboutDialog(
                                context: context,
                                applicationIcon: Image.asset(
                                  'assets/logo-spairo.png',
                                  width: 50,
                                  height: 50,
                                ),
                                applicationName: 'Spairo',
                                applicationVersion: '1.0.0',
                                applicationLegalese:
                                    '© 2026 Spairo.\nجميع الحقوق محفوظة.',
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'تطبيق Spairo هو منصتك المتكاملة والموثوقة لتجارة قطع غيار السيارات.\n\nنهدف لتسهيل تجربة العناية بسيارتك من خلال توفير تقنيات الذكاء الاصطناعي المتقدمة؛ حيث يمكنك البحث عن القطع التي تحتاجها بمجرد تصويرها، أو من خلال التحدث مع المساعد الذكي، لضمان حصولك على القطعة الصحيحة بكل سهولة ودقة وفي وقت قياسي.',
                                    style: TextStyle(fontSize: 14, height: 1.6),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          ),
                          DrawerListTileWidget(
                            title: 'سياسة الخصوصية',
                            icon: Icons.privacy_tip,
                            onTap: () {
                              Navigator.pop(context);
                              CustomAlertDialogWidget.show(
                                context: context,
                                title: "سياسة الخصوصية",
                                content:
                                    "هنالك العديد من الأنواع المتوفرة لنصوص لوريم إيبسوم، ولكن الغالبية تم تعديلها بشكل ما عبر إدخال بعض النوادر أو الكلمات العشوائية إلى النص. إن كنت تريد أن تستخدم نص لوريم إيبسوم ما، عليك أن تتحقق أولاً أن ليس هناك أي كلمات أو عبارات محرجة أو غير لائقة مخبأة في هذا النص \n هنالك العديد من الأنواع المتوفرة لنصوص لوريم إيبسوم، ولكن الغالبية تم تعديلها بشكل ما عبر إدخال بعض النوادر أو الكلمات العشوائية إلى النص. إن كنت تريد أن تستخدم نص لوريم إيبسوم ما، عليك أن تتحقق أولاً أن ليس هناك أي كلمات أو عبارات محرجة أو غير لائقة مخبأة في هذا النص \n هنالك العديد من الأنواع المتوفرة لنصوص لوريم إيبسوم، ولكن الغالبية تم تعديلها بشكل ما عبر إدخال بعض النوادر أو الكلمات العشوائية إلى النص.  \n هنالك العديد من الأنواع المتوفرة لنصوص لوريم إيبسوم، ولكن الغالبية تم تعديلها بشكل ما عبر إدخال بعض النوادر أو الكلمات العشوائية إلى النص. إن كنت تريد أن تستخدم نص لوريم إيبسوم ما، عليك أن تتحقق أولاً أن ليس هناك أي كلمات أو عبارات محرجة أو غير لائقة مخبأة في هذا النص \n هنالك العديد من الأنواع المتوفرة لنصوص لوريم إيبسوم، ولكن الغالبية تم تعديلها بشكل ما عبر إدخال بعض النوادر أو الكلمات العشوائية إلى النص. إن كنت تريد أن تستخدم نص لوريم إيبسوم ما، عليك أن تتحقق أولاً أن ليس هناك أي كلمات أو عبارات محرجة أو غير لائقة مخبأة في هذا النص",
                                primaryButtonText: "موافق",
                                icon: Icons.privacy_tip,
                              );
                            },
                          ),
                          DrawerListTileWidget(
                            title: 'تواصل معنا',
                            icon: Icons.phone,
                            onTap: () {
                              Navigator.pop(context);
                              showContactManagementBottomSheet(context);
                            },
                          ),
                          DrawerListTileWidget(
                            title: 'الإعدادات',
                            icon: Icons.settings,
                            onTap: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'صفحة الإعدادات قيد التطوير',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: AppColors.primary,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              CustomAlertDialogWidget.show(
                                context: context,
                                title: "تأكيد تسجيل الخروج",
                                content:
                                    "هل أنت متأكد من تسجيل الخروج من التطبيق؟",
                                primaryButtonText: "الغاء",
                                secondaryButtonText: "تسجيل الخروج",
                                icon: Icons.logout,
                                onSecondaryPressed: () async {
                                  context.read<AuthCubit>().logout();
                                  Navigator.pop(context);
                                  context.goNamed(AppRouteConst.login);
                                  await context
                                      .read<GetUserOrdersCubit>()
                                      .getUserOrders();
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
