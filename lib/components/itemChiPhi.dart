import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/formatController.dart';
import '../models/chiphi.dart';

Widget itemChiPhi({required ChiPhi chiPhi}) {
  final loai = chiPhi.loai;
  final tenLoai = loai?.ten ?? "Other";
  final isIncome = loai?.isIncome == true;

  Widget buildIcon() {
    if (loai?.icon == null || loai!.icon!.isEmpty) {
      return _buildTextIcon(tenLoai);
    }

    if (loai!.icon!.startsWith('assets')) {
      return Image.asset(
        loai.icon!,
        width: 24,
        height: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildTextIcon(tenLoai),
      );
    }

    final file = File(loai.icon!);

    if (file.existsSync()) {
      return Image.file(
        file,
        width: 24,
        height: 24,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildTextIcon(tenLoai),
      );
    }

    return _buildTextIcon(tenLoai);
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
            color: Colors.primaries[tenLoai.hashCode % Colors.primaries.length]
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
                chiPhi.ten,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                tenLoai,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),

              const SizedBox(height: 4),

              Text(
                DateFormat('dd/MM/yyyy').format(chiPhi.ngay),
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
              formatMoney(chiPhi.gia * (isIncome ? 1 : -1)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 4),

            if (chiPhi.ghiChu != null && chiPhi.ghiChu!.isNotEmpty)
              Text(
                chiPhi.ghiChu!,
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
