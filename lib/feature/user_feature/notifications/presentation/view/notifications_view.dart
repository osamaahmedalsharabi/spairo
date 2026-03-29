import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/di/injection_container.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import '../view_model/notifications_cubit.dart';
import 'widgets/notifications_header.dart';
import 'widgets/notifications_list.dart';
import 'widgets/notifications_empty.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<NotificationsCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              const NotificationsHeader(),
              Expanded(
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      );
                    }
                    if (state is NotificationsLoaded) {
                      if (state.items.isEmpty) return const NotificationsEmpty();
                      return NotificationsList(items: state.items);
                    }
                    if (state is NotificationsError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
