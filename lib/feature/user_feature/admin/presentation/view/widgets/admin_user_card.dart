import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';
import 'package:sparioapp/Widgets/custom_alert_dialog_widget.dart';
import '../../view_model/admin_cubit.dart';

class AdminUserCard extends StatelessWidget {
  final UserEntity user;
  const AdminUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
                AppColors.primary.withOpacity(0.15),
            child: Text(
              user.name.isNotEmpty
                  ? user.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: _buildInfo()),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(user.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(user.userType,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            )),
        Text(user.email,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            user.isActive
                ? Icons.toggle_on
                : Icons.toggle_off,
            color: user.isActive
                ? Colors.green
                : Colors.grey,
            size: 32,
          ),
          onPressed: () {
            context.read<AdminCubit>().toggleUserActive(
                user.id, !user.isActive);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline,
              color: Colors.red, size: 22),
          onPressed: () {
            CustomAlertDialogWidget.show(
              context: context,
              title: 'حذف المستخدم',
              content:
                  'هل أنت متأكد من حذف ${user.name}؟',
              onPrimaryPressed: () {
                context
                    .read<AdminCubit>()
                    .deleteUser(user.id);
                Navigator.pop(context);
              },
            );
          },
        ),
      ],
    );
  }
}
