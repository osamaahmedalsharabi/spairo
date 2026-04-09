import 'package:flutter/material.dart';
import 'package:sparioapp/feature/Authantication/domain/entities/user_entity.dart';

/// @deprecated Use the new inline profile design instead.
class ProfileActionsWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileActionsWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) =>
      const SizedBox.shrink();
}
