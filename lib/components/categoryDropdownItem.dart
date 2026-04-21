import 'dart:io';
import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryDropdownItem extends StatelessWidget {
  final Category category;

  const CategoryDropdownItem({super.key, required this.category});

  Widget _buildIcon() {
    if (category.icon == null || category.icon!.isEmpty) {
      return Text(
        category.name[0].toUpperCase(),
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

    return Text(category.name[0].toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // 🔥 QUAN TRỌNG
      children: [
        SizedBox(width: 24, height: 24, child: _buildIcon()),
        const SizedBox(width: 8),
        Flexible(child: Text(category.name, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
