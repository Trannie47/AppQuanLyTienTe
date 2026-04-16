import 'package:dh52201610_luongthihuyentrang/components/itemCategory.dart';
import 'package:dh52201610_luongthihuyentrang/components/itemexpenses.dart';
import 'package:dh52201610_luongthihuyentrang/models/category.dart';
import 'package:flutter/material.dart';

class ListCategoryPage extends StatefulWidget {
  final List<Category> categories;

  const ListCategoryPage({Key? key, required this.categories})
    : super(key: key);

  @override
  State<ListCategoryPage> createState() => _ListCategoryPageState();
}

class _ListCategoryPageState extends State<ListCategoryPage> {
  late final List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh mục')),
      body: _categories.isEmpty
          ? const Center(child: Text("Chưa có dữ liệu"))
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return ItemCategory(category: _categories[index]);
              },
            ),
    );
  }
}
