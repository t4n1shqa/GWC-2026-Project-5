import 'package:http/http.dart' as http;
import 'dart:convert';

class AIService {
  static const String baseUrl = "http://127.0.0.1:8000";
// interview questions endpoint
  static Future<String> getInterviewQuestions({
    required String jobRole,
    required String experienceLevel,
    required String major,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/interview-questions'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "job_role": jobRole,
        "experience_level": experienceLevel,
        "major": major,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["questions"];
    } else {
      throw Exception("Failed to get questions");
    }
  }

static Future<Map<String, dynamic>> reviewResume(List<int> pdfBytes) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/resume-review'),
  );
  request.files.add(
    http.MultipartFile.fromBytes('file', pdfBytes, filename: 'resume.pdf'),
  );

  final response = await request.send();
  final body = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    return jsonDecode(body) as Map<String, dynamic>; // ← return the whole map
  } else {
    throw Exception("Failed to review resume: $body");
  }
}

}