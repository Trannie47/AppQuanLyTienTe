import 'package:dh52201610_luongthihuyentrang/controllers/formatController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/ProcessImage.dart';
import '../models/expense.dart';

Widget ItemExpenses({required Expense expense}) {
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
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child:
                (expense.category?.icon != null &&
                    expense.category!.icon!.contains('assets'))
                ? Image.asset(
                    getImagePath(expense.category!.icon!),
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  )
                : Text(
                    expense.category?.icon ?? "❓",
                    style: const TextStyle(fontSize: 20),
                  ),
          ),
        ),

        const SizedBox(width: 12),

        /// INFO
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Text(
                expense.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              /// CATEGORY
              Text(
                expense.category?.name ?? "Other",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),

              const SizedBox(height: 4),

              /// DATE
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
              "${formatMoney(expense.amount * (expense.category?.isIncome == true ? 1 : -1))} ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: expense.category?.isIncome == true
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 4),

            /// NOTE (optional)
            if (expense.note != null)
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
