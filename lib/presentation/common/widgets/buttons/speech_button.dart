import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../dialogs/speech_dialog.dart';

class SpeechButton extends StatelessWidget {
  final Function(String) onResult;

  const SpeechButton({super.key, required this.onResult});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      onPressed: () async {
        var status = await Permission.microphone.status;

        if (status.isGranted) {
          _showSpeechDialog(context);
        } else if (status.isPermanentlyDenied) {
          _showSettingsDialog(context);
        } else {
          var result = await Permission.microphone.request();
          if (result.isGranted) {
            _showSpeechDialog(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("WE NEED A MIC PERMISSION FOR USEAGE"),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      child: const Icon(Icons.mic, color: Colors.white),
    );
  }

  void _showSpeechDialog(BuildContext context) async {
    final String? result = await showGeneralDialog<String>(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const Center(child: SpeechDialog());
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - animation1.value)),
          child: Opacity(opacity: animation1.value, child: child),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("마이크 권한 필요"),
        content: const Text("이 기능을 사용하려면 설정에서 마이크 권한을 허용해주세요."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          ElevatedButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("설정으로 이동"),
          ),
        ],
      ),
    );
  }
}
