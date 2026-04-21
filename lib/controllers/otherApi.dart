import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double?> getRate(String from, String to) async {
  final url = Uri.parse(
    'https://v6.exchangerate-api.com/v6/80c952c3122bbefce4863dc5/latest/$from',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['conversion_rates'][to];
  }
  return null;
}
