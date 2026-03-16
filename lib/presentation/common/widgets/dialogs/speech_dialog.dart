import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechDialog extends StatefulWidget {
  const SpeechDialog({super.key});

  @override
  State<SpeechDialog> createState() => _SpeechDialogState();
}

class _SpeechDialogState extends State<SpeechDialog> {
  final SpeechToText _speechToText = SpeechToText();
  String _wordsSpoken = "듣고 있어요...";
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() {
          _wordsSpoken = result.recognizedWords;
        });
        // 인식이 완료되면 약간의 지연 후 결과 반환
        if (result.finalResult) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) Navigator.pop(context, _wordsSpoken);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("음성 인식 중", textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mic, size: 50, color: Colors.blue),
          const SizedBox(height: 20),
          Text(_wordsSpoken, style: const TextStyle(fontSize: 18)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("취소"),
        )
      ],
    );
  }
}