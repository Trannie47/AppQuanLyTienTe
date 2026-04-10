import 'package:flutter/material.dart';
import '../../components/itemExpenses.dart';
import '../../models/expense.dart';

class OutcomePage extends StatefulWidget {
  final List<Expense> list;

  const OutcomePage({super.key, required this.list});

  @override
  State<OutcomePage> createState() => _OutcomePageState();
}

class _OutcomePageState extends State<OutcomePage> {
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
                return ItemExpenses(expense: widget.list[index]);
              },
            ),
    );
  }
}
