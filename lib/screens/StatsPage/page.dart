import 'package:dh52201610_luongthihuyentrang/controllers/formatController.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../models/expense.dart';

class StatsPage extends StatefulWidget {
  final List<Expense> list;

  const StatsPage({super.key, required this.list});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime selectedMonth = DateTime.now();

  /// null = tất cả | true = thu | false = chi
  bool? filterIncome;

  /// 🔥 GROUP DATA
  Map<String, Map<String, dynamic>> getData() {
    Map<String, Map<String, dynamic>> data = {};

    for (var e in widget.list) {
      if (e.date.month == selectedMonth.month &&
          e.date.year == selectedMonth.year) {
        bool isIncome = e.category?.isIncome == true;

        /// 🔥 FILTER
        if (filterIncome != null && isIncome != filterIncome) continue;

        String name = e.category?.name ?? "Khác";

        if (!data.containsKey(name)) {
          data[name] = {"total": 0.0, "isIncome": isIncome};
        }

        data[name]!["total"] += e.amount;
      }
    }

    return data;
  }

  /// 🔥 PICK MONTH
  Future<void> _pickMonth() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedMonth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = getData();

    final total = data.values.fold(0.0, (a, b) => a + (b["total"] as double));

    return Scaffold(
      appBar: AppBar(title: const Text("Thống kê")),
      body: Column(
        children: [
          const SizedBox(height: 16),

          /// 🔥 THÁNG
          Text(
            "Tháng ${selectedMonth.month}/${selectedMonth.year}",
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 10),

          /// 🔥 NÚT CHỌN THÁNG
          ElevatedButton(
            onPressed: _pickMonth,
            child: const Text("Chọn tháng"),
          ),

          const SizedBox(height: 10),

          /// 🔥 FILTER THU / CHI
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text("Tất cả"),
                selected: filterIncome == null,
                onSelected: (_) => setState(() => filterIncome = null),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text("Thu"),
                selected: filterIncome == true,
                onSelected: (_) => setState(() => filterIncome = true),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text("Chi"),
                selected: filterIncome == false,
                onSelected: (_) => setState(() => filterIncome = false),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// 🔥 PIE CHART
          Expanded(
            child: PieChart(
              PieChartData(
                sections: data.entries.map((entry) {
                  final value = entry.value["total"] as double;
                  final isIncome = entry.value["isIncome"] as bool;

                  return PieChartSectionData(
                    color: isIncome ? Colors.green : Colors.red,
                    value: value,
                    title: "${(value / total * 100).toStringAsFixed(1)}%",
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          /// 🔥 LEGEND
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: data.entries.map((entry) {
                final value = entry.value["total"] as double;
                final isIncome = entry.value["isIncome"] as bool;

                return Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(entry.key),
                    const Spacer(),
                    Text(formatMoney(value)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
