import 'package:dh52201610_luongthihuyentrang/components/itemLoai.dart';
import 'package:dh52201610_luongthihuyentrang/controllers/loaiControler.dart';
import 'package:dh52201610_luongthihuyentrang/models/loai.dart';
import 'package:flutter/material.dart';
import '../../../components/topSwitchTab.dart';
import '../../../controllers/chiPhiControler.dart';
import 'LoaiForm/LoaiForm.dart';

class DsLoai extends StatefulWidget {
  final List<Loai> loais;
  final bool isIncome;

  const DsLoai({Key? key, required this.loais, this.isIncome = false})
    : super(key: key);

  @override
  State<DsLoai> createState() => _DsLoaiState();
}

class _DsLoaiState extends State<DsLoai> {
  late List<Loai> _loais;
  bool _isIncome = false;

  List<Loai> get loaiDuocLoc =>
      _loais.where((c) => c.isIncome == _isIncome).toList();

  @override
  void initState() {
    super.initState();
    _loais = widget.loais;
    _isIncome = widget.isIncome;
    loaiController.get().then((cats) {
      setState(() => _loais = cats);
    });
  }

  //#TODO: Xử lý sửa/xóa danh mục ở đây
  Future<void> _editCategory(Loai category) async {
    // Hiển thị form chỉnh sửa với dữ liệu của category
    final loaiDuocCapNhat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoaiForm(
          isIncome: category.isIncome,
          loai: category, // 🔥 truyền vào
        ),
      ),
    );
    if (loaiDuocCapNhat != null && loaiDuocCapNhat is Loai) {
      setState(() {
        final index = _loais.indexOf(category);
        if (index != -1) {
          _loais[index] = loaiDuocCapNhat;
          loaiController.update(loaiDuocCapNhat);
        }
      });
    }
  }

  Future<void> _deleteCategory(Loai category) async {
    /// 🔥 kiểm tra trước
    final hasData = await ChiPhiController.hasExpenseByCategory(category.stt);

    if (hasData) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Không thể xoá"),
          content: Text("Danh mục này đã có dữ liệu, không thể xoá."),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn xóa danh mục này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _loais.remove(category);
      });

      await loaiController.delete(category.stt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _loais); // 🔥 trả dữ liệu
          },
        ),
      ),

      /// 🔥 NÚT + Ở GÓC PHẢI
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCategory = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoaiForm(isIncome: _isIncome)),
          );

          if (newCategory != null && newCategory is Loai) {
            setState(() {
              _loais.add(newCategory);
              loaiController.add(newCategory);
            });
          }
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            TopSwitchTab(
              isLeftSelected: !_isIncome,
              leftText: "Chi tiêu",
              rightText: "Thu nhập",
              leftIcon: Icons.shopping_cart,
              rightIcon: Icons.attach_money,
              leftColor: Colors.red,
              rightColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  _isIncome = !value;
                });
              },
            ),

            /// 🔥 FIX LỖI: bọc Expanded
            Expanded(
              child: loaiDuocLoc.isEmpty
                  ? const Center(child: Text("Chưa có dữ liệu"))
                  : ListView.builder(
                      itemCount: loaiDuocLoc.length,
                      itemBuilder: (context, index) {
                        return itemLoai(
                          category: loaiDuocLoc[index],
                          onEdit: () => _editCategory(loaiDuocLoc[index]),
                          onDelete: () => _deleteCategory(loaiDuocLoc[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
