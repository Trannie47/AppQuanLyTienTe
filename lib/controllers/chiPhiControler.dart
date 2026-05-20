import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chiphi.dart';

class ChiPhiController {
  static final supabase = Supabase.instance.client;

  /// GET ALL
  static Future<List<ChiPhi>> get() async {
    final data = await supabase
        .from('chiphi')
        .select('*, loai(*)')
        .order('ngay', ascending: false);

    return (data as List).map((e) => ChiPhi.fromJson(e)).toList();
  }

  /// ADD
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
        .select('*, loai(*)')
        .single();

    return ChiPhi.fromJson(data);
  }

  /// UPDATE
  static Future<void> update(ChiPhi chiphi) async {
    if (chiphi.id == null) return;

    await supabase
        .from('chiphi')
        .update({
          'ten': chiphi.ten,
          'gia': chiphi.gia,
          'loai_stt': chiphi.loai?.stt,
          'ngay': chiphi.ngay.toIso8601String(),
          'ghiChu': chiphi.ghiChu,
        })
        .eq('id', chiphi.id!);
  }

  /// DELETE
  static Future<void> delete(int id) async {
    await supabase.from('chiphi').delete().eq('id', id);
  }

  /// CHECK CATEGORY
  static Future<bool> hasExpenseByCategory(int categoryId) async {
    final data = await supabase
        .from('chiphi')
        .select('id')
        .eq('loai_stt', categoryId)
        .limit(1);

    return (data as List).isNotEmpty;
  }
}
