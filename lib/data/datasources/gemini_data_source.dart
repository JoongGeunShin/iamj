import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiDataSource {
  final GenerativeModel _model;

  GeminiDataSource(String apiKey)
      : _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.1,
      topP: 0.95,
      topK: 40,
      responseMimeType: 'application/json',
    ),
    requestOptions: const RequestOptions(apiVersion: 'v1beta'),
  );

  Future<Map<String, dynamic>> analyzeText(String prompt) async {
    final finalPrompt = "$prompt\n\nReturn the result in valid JSON format.";
    final content = [Content.text(finalPrompt)];

    try {
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception("API 응답이 비어있습니다.");
      }
      String cleanText = response.text!
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleanText) as Map<String, dynamic>;
    } catch (e) {
      print("Gemini 분석 중 에러 발생: $e");
      rethrow;
    }
  }
}