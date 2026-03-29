import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../feature/Authantication/presentation/cubit/auth_cubit.dart';
import '../feature/Authantication/presentation/cubit/auth_state.dart';

class UserTypeDropdown extends StatelessWidget {
  const UserTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (p, c) => c is UserTypeChanged,
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DropdownButtonFormField<String>(
            value: cubit.selectedUserType,
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              labelText: 'نوع الحساب',
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color(0xffFCA042),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'مستخدم', child: Text('مستخدم')),
              DropdownMenuItem(value: 'مورد', child: Text('مورد')),
              DropdownMenuItem(value: 'مهندس', child: Text('مهندس')),
            ],
            onChanged: (v) => v != null ? cubit.changeUserType(v) : null,
          ),
        );
      },
    );
  }
}
