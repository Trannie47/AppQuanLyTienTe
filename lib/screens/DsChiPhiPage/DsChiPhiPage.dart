import 'package:dh52201610_luongthihuyentrang/controllers/chiPhiControler.dart';
import 'package:dh52201610_luongthihuyentrang/models/chiphi.dart';
import 'package:flutter/material.dart';
import '../../components/itemChiPhi.dart';
import '../ChiPhiForm/ChiPhiForm.dart';

class DsChiPhiPage extends StatefulWidget {
  final List<ChiPhi> list;

  const DsChiPhiPage({super.key, required this.list});

  @override
  State<DsChiPhiPage> createState() => _DsChiPhiPageState();
}

class _DsChiPhiPageState extends State<DsChiPhiPage> {
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
      final int? id = widget.list[index].id; // 🔥 lấy trước

      setState(() {
        widget.list.removeAt(index); // xoá UI
      });
      if (id != null) {
        await ChiPhiController.delete(id); // xoá DB
      }
    }
  }

  //Load lại data sau khi vuốt lên
  Future<void> _loadData() async {
    final data = await ChiPhiController.get();
    setState(() {
      widget.list.clear();
      widget.list.addAll(data);
    });
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
          : RefreshIndicator(
              onRefresh: () => _loadData(),
              child: ListView.builder(
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  final item = widget.list[index];

                  return InkWell(
                    /// 🔥 CLICK → EDIT
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChiPhiForm(expense: item),
                        ),
                      );

                      if (updated != null) {
                        setState(() {
                          widget.list[index] = updated;
                          ChiPhiController.update(updated);
                        });
                      }
                    },

                    /// 🔥 NHẤN GIỮ → XOÁ
                    onLongPress: () {
                      _confirmDelete(index);
                    },

                    child: itemChiPhi(chiPhi: item),
                  );
                },
              ),
            ),
    );
  }
}
