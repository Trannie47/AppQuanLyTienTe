import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense.dart';

class ExpenseController {
  static final supabase = Supabase.instance.client;

  /// 🔥 GET ALL (JOIN CATEGORY)
  static Future<List<Expense>> get() async {
    final data = await supabase
        .from('expenses')
        .select('*, categories(*)')
        .order('date', ascending: false);

    return (data as List)
        .map((e) => Expense.fromJson(e)) // 🔥 FIX
        .toList();
  }

  /// 🔥 ADD (KHÔNG gửi id)
  static Future<Expense?> add(Expense expense) async {
    final data = await supabase
        .from('expenses')
        .insert({
          'title': expense.title,
          'amount': expense.amount,
          'category_stt': expense.category?.stt,
          'date': expense.date.toIso8601String(),
          'note': expense.note,
        })
        .select('*, categories(*)') // 🔥 lấy luôn category
        .single();

    return Expense.fromJson(data);
  }

  /// 🔥 UPDATE
  static Future<void> update(Expense expense) async {
    await supabase
        .from('expenses')
        .update({
          'title': expense.title,
          'amount': expense.amount,
          'category_stt': expense.category?.stt,
          'date': expense.date.toIso8601String(),
          'note': expense.note,
        })
        .eq('id', expense.id); // id từ DB
  }

  /// 🔥 DELETE (int id)
  static Future<void> delete(int id) async {
    await supabase.from('expenses').delete().eq('id', id);
  }

  static Future<bool> hasExpenseByCategory(int categoryId) async {
    final data = await supabase
        .from('expenses')
        .select('id')
        .eq('category_stt', categoryId)
        .limit(1);

    return (data as List).isNotEmpty;
  }
}
