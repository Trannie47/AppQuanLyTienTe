import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryController {
  static final supabase = Supabase.instance.client;

  /// 🔥 GET ALL
  static Future<List<Category>> get() async {
    final data = await supabase
        .from('categories')
        .select()
        .order('stt', ascending: true);

    return (data as List).map((e) => Category.fromJson(e)).toList();
  }

  /// ADD (KHÔNG gửi stt)
  static Future<void> add(Category category) async {
    await supabase.from('categories').insert({
      'name': category.name,
      'icon': category.icon,
      'is_income': category.isIncome,
    });
  }

  ///  UPDATE
  static Future<void> update(Category category) async {
    await supabase
        .from('categories')
        .update({
          'name': category.name,
          'icon': category.icon,
          'is_income': category.isIncome,
        })
        .eq('stt', category.stt);
  }

  /// 🔥 DELETE
  static Future<void> delete(int stt) async {
    await supabase.from('categories').delete().eq('stt', stt);
  }
}
