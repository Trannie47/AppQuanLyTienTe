import 'dart:io';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../controllers/ProcessImage.dart';

Widget ItemCategory({
  required Category category,
  Function()? onEdit,
  Function()? onDelete,
  bool compact = false,
}) {
  Widget buildIcon() {
    if (category.icon == null || category.icon!.isEmpty) {
      return _buildTextIcon(category);
    }

    if (category.icon!.startsWith('assets')) {
      return Image.asset(
        category.icon!,
        width: compact ? 20 : 24,
        height: compact ? 20 : 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildTextIcon(category),
      );
    }

    final file = File(category.icon!);

    if (file.existsSync()) {
      return Image.file(
        file,
        width: compact ? 20 : 24,
        height: compact ? 20 : 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildTextIcon(category),
      );
    }

    return _buildTextIcon(category);
  }

  return Container(
    margin: compact
        ? EdgeInsets.zero
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    padding: compact ? const EdgeInsets.all(6) : const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: compact
          ? []
          : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
    ),
    child: Row(
      children: [
        /// ICON
        Container(
          width: compact ? 32 : 45,
          height: compact ? 32 : 45,
          decoration: BoxDecoration(
            color: Colors
                .primaries[category.name.hashCode % Colors.primaries.length]
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: buildIcon()),
        ),

        const SizedBox(width: 8),

        /// NAME
        Expanded(
          child: Text(
            category.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 14 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        /// ACTIONS (chỉ hiện khi KHÔNG compact)
        if (!compact && (onEdit != null || onDelete != null))
          Row(
            children: [
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
      ],
    ),
  );
}

/// fallback icon
Widget _buildTextIcon(Category category) {
  return Text(
    category.name.isNotEmpty ? category.name[0].toUpperCase() : "❓",
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}
