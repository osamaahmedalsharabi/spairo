import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/feature/user_feature/experts/presentation/view_model/get_experts/get_experts_cubit.dart';
import 'widgets/experts_list_widget.dart';
import 'widgets/expert_shimmer_widget.dart';

class ExpertsView extends StatelessWidget {
  const ExpertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await BlocProvider.of<GetExpertsCubit>(context).getExperts();
      },
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'أفضل الخبراء لخدمتك',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'مجموعة من المهندسين المعتمدين لمساعدتك',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<GetExpertsCubit, GetExpertsState>(
              builder: (context, state) {
                if (state is GetExpertsLoading || state is GetExpertsInitial) {
                  return const ExpertShimmerWidget();
                } else if (state is GetExpertsSuccess) {
                  return ExpertsListWidget(experts: state.experts);
                } else if (state is GetExpertsFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
