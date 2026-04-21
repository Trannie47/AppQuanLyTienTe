import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/CategoryDropdownItem.dart';
import '../../components/topSwitchTab.dart';
import '../../controllers/categoryControler.dart';
import '../../controllers/otherApi.dart';
import '../../models/expense.dart';
import '../../models/category.dart';
import 'ListCategory/page.dart';

class ExpenseFormPage extends StatefulWidget {
  final Expense? expense;

  const ExpenseFormPage({super.key, this.expense});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool isIncome = false;

  Category? selectedCategory;
  late List<Category> _categories = [];

  final List<String> _currencies = [
    'VND',
    'USD',
    'EUR',
    'JPY',
    'KRW',
    'CNY',
    'GBP',
    'AUD',
    'CAD',
    'SGD',
  ];

  List<Category> get filteredCategories =>
      _categories.where((c) => c.isIncome == isIncome).toList();

  @override
  void initState() {
    super.initState();
    _loadCategories();

    /// 🔥 nếu edit thì fill dữ liệu
    if (widget.expense != null) {
      final e = widget.expense!;
      _titleController.text = e.title;
      _amountController.text = e.amount.toString();
      _noteController.text = e.note ?? '';
      _selectedDate = e.date;
      isIncome = e.category!.isIncome;
    }
  }

  void _loadCategories() async {
    final cats = await CategoryController.get();

    setState(() {
      _categories = cats;

      /// 🔥 FIX: đồng bộ category khi edit
      if (widget.expense != null) {
        selectedCategory = _categories.firstWhere(
          (c) => c.name == widget.expense!.category!.name,
          orElse: () => _categories.first,
        );
      } else {
        selectedCategory = filteredCategories.isNotEmpty
            ? filteredCategories.first
            : null;
      }
    });
  }

  Future<void> _selectCategory() async {
    final List<Category>? updatedList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ListCategoryPage(categories: _categories, isIncome: isIncome),
      ),
    );

    if (updatedList != null) {
      setState(() {
        _categories = updatedList;
        selectedCategory = filteredCategories.first;
      });
    }
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

      Navigator.pop(context, expense);
    }
  }

  /// 🔥 POPUP CHUYỂN TIỀN
  Future<void> _openCurrencyConverter() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        String fromCurrency = 'USD';
        TextEditingController fromController = TextEditingController();
        TextEditingController toController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Chuyển đổi tiền'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: fromController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Số tiền',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: fromCurrency,
                    items: _currencies
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => fromCurrency = v!,
                    decoration: const InputDecoration(
                      labelText: 'Từ',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔥 NÚT CHUYỂN ĐỔI
                  ElevatedButton.icon(
                    onPressed: () async {
                      double input = double.tryParse(fromController.text) ?? 0;

                      if (input > 0) {
                        final rate = await getRate(fromCurrency, 'VND');

                        if (rate != null) {
                          double result = input * rate;
                          toController.text = result.toStringAsFixed(0);

                          setStateDialog(() {});
                        }
                      }
                    },
                    icon: const Icon(Icons.swap_vert),
                    label: const Text('Chuyển đổi'),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: toController,
                    keyboardType: TextInputType.number,
                    readOnly: true, // 🔥 khóa nhập
                    enableInteractiveSelection: false,
                    decoration: const InputDecoration(
                      labelText: 'Kết quả (VND)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
                TextButton(
                  onPressed:
                      (toController.text.isEmpty ||
                          (double.tryParse(toController.text) ?? 0) <= 0)
                      ? null
                      : () {
                          Navigator.pop(context, toController.text);
                        },
                  child: const Text('Nhận'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result.toString().isNotEmpty) {
      _amountController.text = result.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null ? 'Thêm Chi Tiêu' : 'Chỉnh sửa Chi Tiêu',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TopSwitchTab(
                isLeftSelected: !isIncome,
                leftText: "Chi tiêu",
                rightText: "Thu nhập",
                leftIcon: Icons.shopping_cart,
                rightIcon: Icons.attach_money,
                leftColor: Colors.red,
                rightColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    isIncome = !value;
                    selectedCategory = filteredCategories.isNotEmpty
                        ? filteredCategories.first
                        : null;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nhập tiêu đề' : null,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
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
                  ),
                  IconButton(
                    onPressed: _openCurrencyConverter,
                    icon: const Icon(Icons.attach_money_outlined),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: filteredCategories.contains(selectedCategory)
                          ? selectedCategory
                          : null,
                      items: filteredCategories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: CategoryDropdownItem(category: cat),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => selectedCategory = value),
                      decoration: const InputDecoration(
                        labelText: 'Danh mục',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _selectCategory,
                    icon: const Icon(Icons.menu),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
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
