import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiDataSource {
  final GenerativeModel _model;

  GeminiDataSource(String apiKey)
      : _model = GenerativeModel(
    model: 'gemini-3-flash-latest',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.1,
      topP: 0.95,
      topK: 40,
    ),
    requestOptions: const RequestOptions(apiVersion: 'v1'),
  );

  Future<Map<String, dynamic>> analyzeText(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);

    if (response.text == null) throw Exception("API 응답이 비어있습니다.");
    String cleanText = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
    return jsonDecode(cleanText);
  }
}