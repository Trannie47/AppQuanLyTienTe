import 'package:dh52201610_luongthihuyentrang/controllers/expenseControler.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'ExpenseFormPage/page.dart';
import 'ListExpensePage/page.dart';
import 'StatsPage/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  List<Expense> list = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// 🔥 LOAD DATA (TỐI ƯU)
  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      final data = await ExpenseController.get();

      setState(() {
        list = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Lỗi load data: $e");
    }
  }

  /// 🔥 MỞ TRANG THÊM (TỐI ƯU)
  Future<void> _openAddOutcomePage() async {
    final Expense? newExpense = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExpenseFormPage()),
    );

    if (newExpense != null) {
      /// 🔥 gọi API trước để lấy ID thật
      final saved = await ExpenseController.add(newExpense);

      if (saved != null) {
        setState(() {
          list.insert(0, saved); // ✅ dùng luôn data từ DB
          currentPage = 0;
        });
      }
    }
  }

  /// 🔥 CHỌN SCREEN
  Widget get currentScreen {
    switch (currentPage) {
      case 0:
        return ListExpensePage(list: list);
      case 1:
        return StatsPage(list: list);
      default:
        return ListExpensePage(list: list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageStorage(bucket: bucket, child: currentScreen),

      /// 🔥 FAB
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddOutcomePage,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// 🔥 BOTTOM BAR
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildButton(Icons.attach_money, "Chi", 0),
              buildButton(Icons.bar_chart, "Thống kê", 1),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 BUTTON NAV
  Widget buildButton(IconData icon, String text, int index) {
    final isSelected = currentPage == index;

    return MaterialButton(
      onPressed: () {
        if (currentPage != index) {
          setState(() {
            currentPage = index;
          });
        }
      },
      minWidth: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
