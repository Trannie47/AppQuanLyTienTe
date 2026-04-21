import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/category.dart';

class CategoryFormPage extends StatefulWidget {
  final bool isIncome;
  final Category? category;

  const CategoryFormPage({super.key, required this.isIncome, this.category});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  late Category? _category;

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      _category = widget.category!;
      _nameController.text = widget.category!.name;

      if (widget.category!.icon.isNotEmpty) {
        _image = File(widget.category!.icon);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _showImageSource() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Thư viện"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) return;

    if (widget.category != null) {
      // Sửa danh mục
      Category updatedCategory = widget.category!.copyWith(
        name: _nameController.text.trim(),
        icon: _image?.path ?? widget.category!.icon,
      );
      Navigator.pop(context, updatedCategory);
    } else {
      final Category category = Category(
        name: _nameController.text.trim(),
        icon: _image?.path ?? "",
        isIncome: widget.isIncome,
      );

      Navigator.pop(context, category);
      // Thêm mới danh mục
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? "Thêm danh mục" : "Sửa danh mục"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImageSource,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.add_a_photo),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Tên",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text(widget.category != null ? "Lưu" : "Thêm"),
            ),
          ],
        ),
      ),
    );
  }
}
