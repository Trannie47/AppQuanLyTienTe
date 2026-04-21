import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/formatController.dart';
import '../models/expense.dart';

Widget ItemExpenses({required Expense expense}) {
  final category = expense.category;
  final categoryName = category?.name ?? "Other";
  final isIncome = category?.isIncome == true;

  Widget buildIcon() {
    if (category?.icon == null || category!.icon!.isEmpty) {
      return _buildTextIcon(categoryName);
    }

    if (category!.icon!.startsWith('assets')) {
      return Image.asset(
        category.icon!,
        width: 24,
        height: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildTextIcon(categoryName),
      );
    }

    final file = File(category.icon!);

    if (file.existsSync()) {
      return Image.file(
        file,
        width: 24,
        height: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildTextIcon(categoryName),
      );
    }

    return _buildTextIcon(categoryName);
  }

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
        /// 🔥 ICON (GIỐNG CATEGORY)
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors
                .primaries[categoryName.hashCode % Colors.primaries.length]
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: buildIcon()),
        ),

        const SizedBox(width: 12),

        /// INFO
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                categoryName,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),

              const SizedBox(height: 4),

              Text(
                DateFormat('dd/MM/yyyy').format(expense.date),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),

        /// AMOUNT
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatMoney(expense.amount * (isIncome ? 1 : -1)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 4),

            if (expense.note != null && expense.note!.isNotEmpty)
              Text(
                expense.note!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildTextIcon(String name) {
  return Text(
    name.isNotEmpty ? name[0].toUpperCase() : "❓",
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}
