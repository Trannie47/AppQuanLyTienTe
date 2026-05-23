import 'package:dh52201610_luongthihuyentrang/components/ItemloaiDropdown.dart';
import 'package:dh52201610_luongthihuyentrang/models/chiphi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/topSwitchTab.dart';
import '../../controllers/loaiControler.dart';
import '../../controllers/otherApi.dart';
import '../../models/loai.dart';
import 'DsLoai/DsLoai.dart';

class ChiPhiForm extends StatefulWidget {
  final ChiPhi? expense;

  const ChiPhiForm({super.key, this.expense});

  @override
  State<ChiPhiForm> createState() => _ChiPhiFormState();
}

class _ChiPhiFormState extends State<ChiPhiForm> {
  final _formKey = GlobalKey<FormState>();
  final _tenController = TextEditingController();
  final _giaController = TextEditingController();
  final _ghiChuController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool isIncome = false;

  Loai? loaiDuocChon;
  late List<Loai> _loais = [];

  final List<String> _tiente = [
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

  List<Loai> get dsLoaiDuocLoc =>
      _loais.where((c) => c.isIncome == isIncome).toList();

  @override
  void initState() {
    super.initState();
    _loadLoai();

    /// 🔥 nếu edit thì fill dữ liệu
    if (widget.expense != null) {
      final e = widget.expense!;
      _tenController.text = e.ten;
      _giaController.text = e.gia.toString();
      _ghiChuController.text = e.ghiChu ?? '';
      _selectedDate = e.ngay;
      isIncome = e.loai!.isIncome;
    }
  }

  void _loadLoai() async {
    final loais = await loaiController.get();

    setState(() {
      _loais = loais;

      /// 🔥 FIX: đồng bộ category khi edit
      if (widget.expense != null) {
        loaiDuocChon = _loais.firstWhere(
          (c) => c.ten == widget.expense!.loai!.ten,
          orElse: () => _loais.first,
        );
      } else {
        loaiDuocChon = dsLoaiDuocLoc.isNotEmpty ? dsLoaiDuocLoc.first : null;
      }
    });
  }

  Future<void> _chonLoai() async {
    final List<Loai>? dsLoaiCapNhat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DsLoai(loais: _loais, isIncome: isIncome),
      ),
    );

    if (dsLoaiCapNhat != null) {
      setState(() {
        _loais = dsLoaiCapNhat;
        loaiDuocChon = dsLoaiDuocLoc.first;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate() && loaiDuocChon != null) {
      final chiPhi = ChiPhi(
        id: widget.expense?.id, // giữ nguyên ID nếu đang edit
        ten: _tenController.text.trim(),
        gia: double.parse(_giaController.text),
        loai: loaiDuocChon!,
        ngay: _selectedDate,
        ghiChu: _ghiChuController.text.trim().isEmpty
            ? null
            : _ghiChuController.text.trim(),
      );

      Navigator.pop(context, chiPhi);
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
                    items: _tiente
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
      _giaController.text = result.toString();
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
                    loaiDuocChon = dsLoaiDuocLoc.isNotEmpty
                        ? dsLoaiDuocLoc.first
                        : null;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _tenController,
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
                      controller: _giaController,
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
                    child: DropdownButtonFormField<Loai>(
                      value: dsLoaiDuocLoc.contains(loaiDuocChon)
                          ? loaiDuocChon
                          : null,
                      items: dsLoaiDuocLoc.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: ItemLoaiThaXuong(category: cat),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => loaiDuocChon = value),
                      decoration: const InputDecoration(
                        labelText: 'Danh mục',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _chonLoai,
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
                controller: _ghiChuController,
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
