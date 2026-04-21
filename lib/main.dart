import 'package:dh52201610_luongthihuyentrang/screens/page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 👈 bắt buộc

  await Supabase.initialize(
    url: 'https://mznzjmrtkjqwzgigxatk.supabase.co',
    anonKey: 'sb_publishable_evavBEbhKyd63omGc9cHgw_QnB0VHqN',
  );

  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
  );
}
