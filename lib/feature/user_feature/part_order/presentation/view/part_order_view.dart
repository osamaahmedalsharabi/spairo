import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/feature/user_feature/home/data/repo/home_repo.dart';
import 'package:sparioapp/feature/user_feature/home/presentation/view_model/get_brand_cars/get_brand_cars_cubit.dart';

import 'package:sparioapp/feature/user_feature/part_order/presentation/view_model/submit_order_cubit.dart';

import 'widgets/part_order_form.dart';

class PartOrderView extends StatelessWidget {
  const PartOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetBrandCarsCubit(sl.get<HomeRepoImpl>()),
        ),
        BlocProvider(create: (context) => sl.get<SubmitOrderCubit>()),
      ],
      child: BlocConsumer<SubmitOrderCubit, SubmitOrderState>(
        listener: (context, state) {
          if (state is SubmitOrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم رفع طلبك بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is SubmitOrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    "طلب قطع غيار",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                body: SafeArea(
                  child: const SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: PartOrderForm(),
                  ),
                ),
              ),
              if (state is SubmitOrderLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
