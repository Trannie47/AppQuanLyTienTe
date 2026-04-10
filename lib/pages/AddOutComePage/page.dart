import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/expense.dart';
import '../../models/category.dart';

class AddOutcomePage extends StatefulWidget {
  const AddOutcomePage({super.key});

  @override
  State<AddOutcomePage> createState() => _AddOutcomePageState();
}

class _AddOutcomePageState extends State<AddOutcomePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<Category> categories = [
    Category(name: "Food", icon: "🍔"),
    Category(name: "Shopping", icon: "🛍️"),
    Category(name: "Transport", icon: "🚗"),
    Category(name: "Invest", icon: "📈"),
    Category(name: "Phone", icon: "📱"),
    Category(name: "Other", icon: "❓"),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final categoryName = _categoryController.text.trim();
      final note = _noteController.text.trim();

      // Tìm category từ list, nếu không có thì dùng Other
      Category? selectedCategory;
      try {
        selectedCategory = categories.firstWhere(
          (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
        );
      } catch (_) {
        selectedCategory = categories.last; // Other
      }

      final expense = Expense(
        title: title,
        amount: amount,
        category: selectedCategory,
        date: _selectedDate,
        note: note.isEmpty ? null : note,
      );

      Navigator.of(context).pop(expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Thu Nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Số tiền phải là số dương';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      decoration: const InputDecoration(
                        labelText: 'Thể loại',
                        border: OutlineInputBorder(),
                      ),
                      value: categories.first,
                      items: categories.map((cat) {
                        return DropdownMenuItem<Category>(
                          value: cat,
                          child: Text('${cat.icon} ${cat.name}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _categoryController.text = value.name;
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Vui lòng chọn thể loại';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // xử lý khi bấm
                    },
                    icon: Icon(Icons.menu),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.date_range),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú (tùy chọn)',
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
