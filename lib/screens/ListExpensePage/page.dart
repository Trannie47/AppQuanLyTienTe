import 'package:dh52201610_luongthihuyentrang/controllers/expenseControler.dart';
import 'package:flutter/material.dart';
import '../../components/itemExpenses.dart';
import '../../models/expense.dart';
import '../ExpenseFormPage/page.dart';

class ListExpensePage extends StatefulWidget {
  final List<Expense> list;

  const ListExpensePage({super.key, required this.list});

  @override
  State<ListExpensePage> createState() => _ListExpensePageState();
}

class _ListExpensePageState extends State<ListExpensePage> {
  /// 🔥 dialog xác nhận xoá
  Future<void> _confirmDelete(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xác nhận"),
          content: const Text("Bạn có muốn xoá khoản thu/chi này không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Không"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Có"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final id = widget.list[index].id; // 🔥 lấy trước

      setState(() {
        widget.list.removeAt(index); // xoá UI
      });

      await ExpenseController.delete(int.parse(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách chi tiêu"),
        centerTitle: true,
      ),
      body: widget.list.isEmpty
          ? const Center(child: Text("Chưa có dữ liệu"))
          : ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                final item = widget.list[index];

                return InkWell(
                  /// 🔥 CLICK → EDIT
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpenseFormPage(expense: item),
                      ),
                    );

                    if (updated != null) {
                      setState(() {
                        widget.list[index] = updated;
                        ExpenseController.update(updated);
                      });
                    }
                  },

                  /// 🔥 NHẤN GIỮ → XOÁ
                  onLongPress: () {
                    _confirmDelete(index);
                  },

                  child: ItemExpenses(expense: item),
                );
              },
            ),
    );
  }
}
