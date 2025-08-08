import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static Future<List<Map<String, String>>> classifyTasks(
      List<String> tasks) async {
    final url = Uri.parse('http://10.0.2.2:5000/classify'); // أو IP جهازك

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'tasks': tasks}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          return body.map<Map<String, String>>((item) {
            if (item is Map<String, dynamic> &&
                item.containsKey('task') &&
                item.containsKey('priority')) {
              return {
                'task': item['task'].toString(),
                'priority': item['priority'].toString(),
              };
            } else {
              throw Exception('Invalid item format in response');
            }
          }).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in classifyTasks: $e');
      rethrow; // نعيد رمي الخطأ عشان اللي يستدعي الدالة يعرف يتصرف فيه
    }
  }
}
