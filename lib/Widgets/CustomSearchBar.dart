// CustomSearch.dart
import 'package:flutter/material.dart';
import '../Core/Theme/app_colors.dart';

class CustomSearch extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;

  const CustomSearch({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {}); // لتحديث زر الـ clear عند الكتابة
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.camera_alt,
            color: Colors.orangeAccent,
            size: 40,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.backgroundSlightlyDarker1,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: widget.controller.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.primary),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
