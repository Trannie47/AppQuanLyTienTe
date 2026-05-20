import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/loai.dart';

class loaiController {
  static final supabase = Supabase.instance.client;

  /// 🔥 GET ALL
  static Future<List<Loai>> get() async {
    final data = await supabase
        .from('loai')
        .select()
        .order('stt', ascending: true);

    return (data as List).map((e) => Loai.fromJson(e)).toList();
  }

  /// ADD (KHÔNG gửi stt)
  static Future<void> add(Loai category) async {
    await supabase.from('loai').insert({
      'ten': category.ten,
      'icon': category.icon,
      'is_income': category.isIncome,
    });
  }

  ///  UPDATE
  static Future<void> update(Loai category) async {
    await supabase
        .from('loai')
        .update({
          'ten': category.ten,
          'icon': category.icon,
          'is_income': category.isIncome,
        })
        .eq('stt', category.stt);
  }

  /// 🔥 DELETE
  static Future<void> delete(int stt) async {
    await supabase.from('loai').delete().eq('stt', stt);
  }
}
