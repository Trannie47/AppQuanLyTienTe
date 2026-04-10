import 'package:dh52201610_luongthihuyentrang/controllers/formatController.dart';
import 'package:dh52201610_luongthihuyentrang/models/category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/ProcessImage.dart';

Widget ItemCategory({required Category category}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        /// ICON CATEGORY
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors
                .primaries[category.name.hashCode % Colors.primaries.length]
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: (category.icon != null && category.icon!.contains('assets'))
                ? Image.asset(
                    getImagePath(category.icon),
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  )
                : Text(
                    category.name.isNotEmpty
                        ? category.name[0].toUpperCase()
                        : "❓",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),

        const SizedBox(width: 12),

        /// INFO
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
