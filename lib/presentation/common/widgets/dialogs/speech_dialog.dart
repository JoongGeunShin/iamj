import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:ui';

class SpeechDialog extends StatefulWidget {
  const SpeechDialog({super.key});

  @override
  State<SpeechDialog> createState() => _SpeechDialogState();
}

class _SpeechDialogState extends State<SpeechDialog>
    with SingleTickerProviderStateMixin {
  final SpeechToText _speechToText = SpeechToText();
  String _wordsSpoken = "Listening to your voice...";

  bool _isListening = false;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _controller.dispose();
    _speechToText.stop();
    super.dispose();
  }

  void _initSpeech() async {
    await _speechToText.initialize(
      onError: (e) => _stopAnimation(),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') _stopAnimation();
      },
    );
  }

  void _toggleListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _stopAnimation();
      setState(() {
        _wordsSpoken = "Tab mic to say";
        _isListening = false;
      });
    } else {
      setState(() {
        _wordsSpoken = "Listening...";
        _isListening = true;
      });
      _controller.repeat(reverse: true);

      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _wordsSpoken = result.recognizedWords;
          });
          if (result.finalResult) {
            Future.delayed(const Duration(milliseconds: 6000), () {
              if (mounted) Navigator.pop(context, _wordsSpoken);
            });
          }
        },
      );
    }
  }

  void _stopAnimation() {
    if (mounted) {
      setState(() => _isListening = false);
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "What's your goal?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40),

              GestureDetector(
                onTap: _toggleListening,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ScaleTransition(
                      scale: Tween<double>(begin: 1.0, end: 1.4).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(
                            alpha: _isListening ? 0.2 : 0.05,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening ? Colors.white : Colors.white24,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              Text(
                _wordsSpoken,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
