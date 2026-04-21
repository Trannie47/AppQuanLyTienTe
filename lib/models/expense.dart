import 'package:intl/intl.dart';
import 'category.dart';

class Expense {
  static int _counter = 0;
  static String _lastDate = '';

  String id;
  String title;
  double amount;
  Category? category;
  DateTime date;
  String? note;

  Expense({
    String? id,
    required this.title,
    required this.amount,
    this.category,
    DateTime? date,
    this.note,
  }) : date = date ?? DateTime.now(),
       id = id ?? _generateId();

  /// AUTO ID
  static String _generateId() {
    final now = DateTime.now();
    final date = DateFormat('yyyyMMdd').format(now);

    if (_lastDate != date) {
      _lastDate = date;
      _counter = 0;
    }

    _counter++;
    final seq = _counter.toString().padLeft(3, '0');
    return '$date$seq';
  }

  /// FROM JSON (Supabase)
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'].toString(),
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),

      /// 👇 FIX: lấy từ join categories
      category: json['categories'] != null
          ? Category.fromJson(json['categories'])
          : null,

      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }

  /// TO JSON (Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,

      /// 👇 FIX: gửi khóa ngoại
      'category_stt': category?.stt,

      'date': date.toIso8601String(),
      'note': note,
    };
  }

  /// COPY WITH
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    Category? category,
    DateTime? date,
    String? note,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount)';
  }
}
