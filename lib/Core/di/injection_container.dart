import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';
import 'package:sparioapp/feature/user_feature/experts/data/repo/experts_repo.dart';
import 'package:sparioapp/feature/user_feature/experts/presentation/view_model/get_experts/get_experts_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brand_cars/get_brand_cars_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brands/get_brands_cubit.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_categories/get_categories_cubit.dart';
import '../../feature/Authantication/data/datasources/auth_remote_data_source.dart';
import '../../feature/Authantication/data/datasources/auth_local_data_source.dart';
import '../../feature/Authantication/data/repositories/auth_repo_impl.dart';
import '../../feature/Authantication/domain/repositories/auth_repo.dart';
import '../../feature/Authantication/presentation/cubit/auth_cubit.dart';
import '../../feature/Authantication/presentation/cubit/get_user_data/get_user_data_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/data/repo/part_order_repo.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/submit_order_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/get_user_orders_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/cancel_order_cubit.dart';
import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/update_order_status_cubit.dart';
import 'package:sparioapp/feature/user_feature/products/data/repositories/products_repo_impl.dart';
import 'package:sparioapp/feature/user_feature/products/domain/repositories/products_repo.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/manage_product_cubit.dart';
import 'package:sparioapp/feature/user_feature/products/presentation/view_model/products_cubit.dart';
import 'package:sparioapp/feature/user_feature/favorites/data/repo/favorites_repo_impl.dart';
import 'package:sparioapp/feature/user_feature/favorites/presentation/view_model/favorites_cubit.dart';
import 'package:sparioapp/feature/user_feature/ai_image_search/data/services/ai_image_search_service.dart';
import 'package:sparioapp/feature/user_feature/ai_image_search/presentation/view_model/ai_image_search_cubit.dart';
import 'package:sparioapp/Core/services/fcm_service.dart';
import 'package:sparioapp/Core/services/notification_service.dart';
import 'package:sparioapp/feature/user_feature/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:sparioapp/feature/user_feature/notifications/data/repositories/notifications_repository.dart';
import 'package:sparioapp/feature/user_feature/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:sparioapp/feature/user_feature/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:sparioapp/feature/user_feature/profile/data/repositories/profile_repository.dart';
import 'package:sparioapp/feature/user_feature/profile/data/repositories/profile_repository_impl.dart';
import 'package:sparioapp/feature/user_feature/profile/presentation/view_model/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => GetUserDataCubit(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl(), sl()));

  sl.registerLazySingleton<ProductsRepo>(() => ProductsRepoImpl());
  sl.registerFactory(() => ProductsCubit(repository: sl()));

  sl.registerFactory(() => GetBrandsCubit(sl.get<HomeRepoImpl>()));
  sl.registerFactory(() => GetCategoriesCubit(sl.get<HomeRepoImpl>()));
  sl.registerLazySingleton(() => ExpertsRepoImpl(sl.get<FirebaseFirestore>()));

  sl.registerFactory(
    () => GetUserOrdersCubit(
      sl.get<PartOrderRepoImpl>(),
      sl.get<AuthLocalDataSource>(),
    ),
  );
  sl.registerFactory(
    () => ManageProductCubit(repository: sl.get<ProductsRepo>()),
  );
  sl.registerFactory(() => SubmitOrderCubit(sl.get<PartOrderRepoImpl>()));
  sl.registerFactory(() => CancelOrderCubit(sl.get<PartOrderRepoImpl>()));
  sl.registerFactory(() => UpdateOrderStatusCubit(sl.get<PartOrderRepoImpl>()));
  // Data sources
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl(), sl(), sl()));
  sl.registerLazySingleton(() => AuthLocalDataSource(Hive.box('userBox')));

  // Services
  sl.registerLazySingleton(() => FCMService());
  sl.registerLazySingleton(() => NotificationService());

  // External (Firebase)
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerFactory(() => GetBrandCarsCubit(sl.get<HomeRepoImpl>()));
  // Home
  sl.registerLazySingleton(() => HomeRepoImpl(sl.get<FirebaseFirestore>()));

  // Experts
  sl.registerFactory(() => GetExpertsCubit(sl()));

  // Part Order
  sl.registerLazySingleton<PartOrderRepoImpl>(() => PartOrderRepoImpl());

  // Favorites
  sl.registerLazySingleton(() => FavoritesRepoImpl(sl.get<FirebaseFirestore>()));
  sl.registerLazySingleton(() => FavoritesCubit(sl.get<FavoritesRepoImpl>()));

  // Notifications
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(sl.get<FirebaseFirestore>()));
  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(sl.get<NotificationsRemoteDataSource>()));
  sl.registerFactory(() => NotificationsCubit(sl.get<NotificationsRepository>()));

  // AI Image Search
  sl.registerLazySingleton(() => AiImageSearchService());
  sl.registerFactory(() => AiImageSearchCubit(sl(), sl.get<ProductsRepo>()));

  // Profile
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl.get<FirebaseFirestore>(), sl.get<FirebaseAuth>()));
  sl.registerFactory(() => ProfileCubit(sl.get<ProfileRepository>()));
}
