import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddDialog extends StatefulWidget {
  final String title;
  final Function(String name, File? image) onAdd;

  const AdminAddDialog({
    super.key,
    required this.title,
    required this.onAdd,
  });

  @override
  State<AdminAddDialog> createState() =>
      _AdminAddDialogState();
}

class _AdminAddDialogState
    extends State<AdminAddDialog> {
  final _nameCtrl = TextEditingController();
  File? _pickedImage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      setState(() => _pickedImage = File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
                labelText: 'الاسم'),
          ),
          const SizedBox(height: 12),
          _ImagePreview(
            image: _pickedImage,
            onPick: _pickImage,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameCtrl.text.isNotEmpty) {
              widget.onAdd(
                _nameCtrl.text.trim(),
                _pickedImage,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final File? image;
  final VoidCallback onPick;
  const _ImagePreview({
    required this.image,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          image: image != null
              ? DecorationImage(
                  image: FileImage(image!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: image == null
            ? const Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      color: Colors.grey, size: 32),
                  SizedBox(height: 4),
                  Text('اختر صورة',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12)),
                ],
              )
            : null,
      ),
    );
  }
}
