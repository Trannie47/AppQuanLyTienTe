import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chiphi.dart';

class ExpenseController {
  static final supabase = Supabase.instance.client;

  /// 🔥 GET ALL (JOIN Loai)
  static Future<List<ChiPhi>> get() async {
    final data = await supabase
        .from('chiphi')
        .select('*, loai(*)')
        .order('ngay', ascending: false);

    return (data as List)
        .map((e) => ChiPhi.fromJson(e)) // 🔥 FIX
        .toList();
  }

  /// 🔥 ADD (KHÔNG gửi id)
  static Future<ChiPhi?> add(ChiPhi expense) async {
    final data = await supabase
        .from('chiphi')
        .insert({
          'ten': expense.ten,
          'gia': expense.gia,
          'loai_stt': expense.loai?.stt,
          'ngay': expense.ngay.toIso8601String(),
          'ghiChu': expense.ghiChu,
        })
        .select('*, loai(*)') // 🔥 lấy luôn category
        .single();

    return ChiPhi.fromJson(data);
  }

  /// 🔥 UPDATE
  static Future<void> update(ChiPhi expense) async {
    await supabase
        .from('chiphi')
        .update({
          'ten': expense.ten,
          'gia': expense.gia,
          'loai_stt': expense.loai?.stt,
          'ngay': expense.ngay.toIso8601String(),
          'ghiChu': expense.ghiChu,
        })
        .eq('id', expense.id); // id từ DB
  }

  /// 🔥 DELETE (int id)
  static Future<void> delete(int id) async {
    await supabase.from('expenses').delete().eq('id', id);
  }

  static Future<bool> hasExpenseByCategory(int categoryId) async {
    final data = await supabase
        .from('chiphi')
        .select('id')
        .eq('loai_stt', categoryId)
        .limit(1);

    return (data as List).isNotEmpty;
  }
}
