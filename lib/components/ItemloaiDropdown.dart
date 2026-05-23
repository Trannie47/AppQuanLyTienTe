import 'dart:io';
import 'package:dh52201610_luongthihuyentrang/models/loai.dart';
import 'package:flutter/material.dart';

class ItemLoaiThaXuong extends StatelessWidget {
  final Loai category;

  const ItemLoaiThaXuong({super.key, required this.category});

  Widget _buildIcon() {
    if (category.icon == null || category.icon!.isEmpty) {
      return Text(
        category.ten[0].toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }

    if (category.icon!.startsWith('assets')) {
      return Image.asset(
        category.icon!,
        width: 20,
        height: 20,
        fit: BoxFit.cover,
      );
    }

    final file = File(category.icon!);
    if (file.existsSync()) {
      return Image.file(file, width: 20, height: 20, fit: BoxFit.cover);
    }

    return Text(category.ten[0].toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // 🔥 QUAN TRỌNG
      children: [
        SizedBox(width: 24, height: 24, child: _buildIcon()),
        const SizedBox(width: 8),
        Flexible(child: Text(category.ten, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
