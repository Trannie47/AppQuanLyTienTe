import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/expense.dart';
import 'AddOutComePage/page.dart';
import 'OutcomePage/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  List<Expense> list = [];

  late List<Widget> _screens;

  //Func
  @override
  void initState() {
    super.initState();
    List<Category> categories = [
      Category(name: "Food", icon: "food"),
      Category(name: "Shopping", icon: "shopping"),
      Category(name: "Transport", icon: "transport"),
      Category(name: "Invest", icon: "invest"),
      Category(name: "Phone", icon: "phone"),
    ];

    /// 👉 DATA TEST (dùng model của bạn)
    list = [
      Expense(title: "Ăn cơm", amount: 50000, category: categories[0]),
      Expense(title: "Mua áo", amount: 200000, category: categories[1]),
      Expense(title: "Đổ xăng", amount: 100000, category: categories[2]),
      Expense(title: "Nạp điện thoại", amount: 50000, category: categories[4]),
      Expense(title: "Đầu tư", amount: 1000000, category: categories[3]),
    ];
    _screens = [OutcomePage(list: list), const StatsPage()];
  }

  Future<void> _openAddOutcomePage() async {
    final Expense? newExpense = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddOutcomePage()),
    );

    if (newExpense != null) {
      setState(() {
        list.insert(0, newExpense); // Thêm vào đầu danh sách
        _screens = [OutcomePage(list: list), const StatsPage()];
        currentPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: _screens[currentPage]),

      /// FAB
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddOutcomePage,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// BOTTOM BAR
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// LEFT
              buildButton(Icons.attach_money, "Chi", 0),

              /// RIGHT
              buildButton(Icons.bar_chart, "THỐNG KÊ", 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(IconData icon, String text, int index) {
    return MaterialButton(
      onPressed: () {
        setState(() {
          currentPage = index;
        });
      },
      minWidth: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: currentPage == index ? Colors.blue : Colors.grey),
          Text(
            text,
            style: TextStyle(
              color: currentPage == index ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= PAGE THỐNG KÊ =================
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "TRANG THỐNG KÊ (STATISTICS)",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
