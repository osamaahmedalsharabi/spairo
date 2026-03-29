import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (p, c) => c is UserTypeChanged || c is ImageSelected,
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        if (cubit.selectedUserType == 'مستخدم' ||
            cubit.selectedUserType == 'مهندس') {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "صورة للسجل التجاري",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final file = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (file != null) cubit.imagePicked(File(file.path));
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: cubit.selectedImage == null
                      ? const Icon(Icons.camera_alt, color: Colors.orange)
                      : const Icon(Icons.check, color: Colors.green),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
