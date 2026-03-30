import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sparioapp/Core/theme%20copy/light_theme.dart';
import 'package:sparioapp/feature/Authantication/presentation/cubit/auth_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brands/get_brands_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_categories/get_categories_cubit.dart';
import 'package:sparioapp/feature/user_feature/experts/presentation/view_model/get_experts/get_experts_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/products_cubit.dart';
import 'package:sparioapp/feature/user_feature/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:sparioapp/generated/l10n.dart';
import 'package:sparioapp/Core/routing/app_router.dart';
import 'firebase_options.dart';
import 'Core/di/injection_container.dart' as di;
import 'package:sparioapp/Core/services/fcm_service.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await di.init();

  // Initialize timeago Arabic locale
  timeago.setLocaleMessages('ar', timeago.ArMessages());

  runApp(const SpairoApp());

  // Initialize FCM after runApp so it doesn't block the splash screen
  di.sl.get<FCMService>().initialize();
}

class SpairoApp extends StatelessWidget {
  const SpairoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl.get<ProductsCubit>()..getAllProducts(),
        ),
        BlocProvider(
          create: (context) => di.sl.get<AuthCubit>()..checkAuthStatus(),
        ),

        BlocProvider(
          create: (context) =>
              GetBrandsCubit(di.sl.get<HomeRepoImpl>())..getBrands(),
        ),
        BlocProvider(
          create: (context) => di.sl.get<GetUserOrdersCubit>()..getUserOrders(),
        ),
        BlocProvider(
          create: (context) =>
              GetCategoriesCubit(di.sl.get<HomeRepoImpl>())..getCategories(),
        ),
        BlocProvider(
          create: (context) => di.sl.get<GetExpertsCubit>()..getExperts(),
        ),
        BlocProvider(
          create: (context) => di.sl.get<FavoritesCubit>()..loadFavorites(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "Spairo",
        locale: const Locale("ar"),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: light(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
