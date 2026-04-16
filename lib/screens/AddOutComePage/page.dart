import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/topSwitchTab.dart';
import '../../models/expense.dart';
import '../../models/category.dart';
import 'ListCategory/page.dart';

class AddOutcomePage extends StatefulWidget {
  const AddOutcomePage({super.key});

  @override
  State<AddOutcomePage> createState() => _AddOutcomePageState();
}

class _AddOutcomePageState extends State<AddOutcomePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  /// 🔥 false = Chi | true = Thu
  bool isIncome = false;

  Category? selectedCategory;

  List<Category> categories = [
    Category(name: "Food", icon: "🍔", isIncome: false),
    Category(name: "Shopping", icon: "🛍️", isIncome: false),
    Category(name: "Transport", icon: "🚗", isIncome: false),

    Category(name: "Lương", icon: "💰", isIncome: true),
    Category(name: "Thưởng", icon: "🎁", isIncome: true),
    Category(name: "Đầu tư", icon: "📈", isIncome: true),
  ];

  List<Category> get filteredCategories =>
      categories.where((c) => c.isIncome == isIncome).toList();

  @override
  void initState() {
    super.initState();
    selectedCategory = filteredCategories.isNotEmpty
        ? filteredCategories.first
        : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  //Chuyển đến trang ListCategoryPage để chọn category
  Future<void> _selectCategory() async {
    final Expense? newExpense = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListCategoryPage(categories: categories),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate() && selectedCategory != null) {
      final expense = Expense(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        category: selectedCategory!,
        date: _selectedDate,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      Navigator.of(context).pop(expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isIncome ? 'Thêm Thu Nhập' : 'Thêm Chi Tiêu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// 🔥 TAB GIỐNG HÌNH (Thu / Chi)
              TopSwitchTab(
                isLeftSelected: !isIncome, // trái = Chi
                leftText: "Chi tiêu",
                rightText: "Thu nhập",
                leftIcon: Icons.shopping_cart,
                rightIcon: Icons.attach_money,
                leftColor: Colors.red,
                rightColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    isIncome = !value;

                    /// 🔥 reset category khi đổi tab
                    selectedCategory = filteredCategories.isNotEmpty
                        ? filteredCategories.first
                        : null;
                  });
                },
              ),

              const SizedBox(height: 16),

              /// TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Nhập tiêu đề' : null,
              ),

              const SizedBox(height: 16),

              /// AMOUNT
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final value = double.tryParse(v ?? '');
                  if (value == null || value <= 0) {
                    return 'Số tiền không hợp lệ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// CATEGORY (fix lỗi value không nằm trong list)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: filteredCategories.contains(selectedCategory)
                          ? selectedCategory
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Danh mục',
                        border: OutlineInputBorder(),
                      ),
                      items: filteredCategories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text('${cat.icon} ${cat.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedCategory = value);
                      },
                      validator: (value) =>
                          value == null ? 'Chọn thể loại' : null,
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// 🔥 NÚT BÊN PHẢI (menu / thêm category)
                  IconButton(
                    onPressed: _selectCategory,
                    icon: const Icon(Icons.menu),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// DATE
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// NOTE
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              ElevatedButton(onPressed: _save, child: const Text('Lưu')),
            ],
          ),
        ),
      ),
    );
  }
}
