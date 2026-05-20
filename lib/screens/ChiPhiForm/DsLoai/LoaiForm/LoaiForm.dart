import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/loai.dart';

class LoaiForm extends StatefulWidget {
  final bool isIncome;
  final Loai? loai;

  const LoaiForm({super.key, required this.isIncome, this.loai});

  @override
  State<LoaiForm> createState() => _LoaiFormState();
}

class _LoaiFormState extends State<LoaiForm> {
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  late Loai? _loai;

  @override
  void initState() {
    super.initState();

    if (widget.loai != null) {
      _loai = widget.loai!;
      _nameController.text = widget.loai!.ten;

      if (widget.loai!.icon.isNotEmpty) {
        _image = File(widget.loai!.icon);
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

    if (widget.loai != null) {
      // Sửa danh mục
      Loai updatedCategory = widget.loai!.copyWith(
        ten: _nameController.text.trim(),
        icon: _image?.path ?? widget.loai!.icon,
      );
      Navigator.pop(context, updatedCategory);
    } else {
      final Loai category = Loai(
        ten: _nameController.text.trim(),
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
        title: Text(widget.loai == null ? "Thêm danh mục" : "Sửa danh mục"),
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
              child: Text(widget.loai != null ? "Lưu" : "Thêm"),
            ),
          ],
        ),
      ),
    );
  }
}
