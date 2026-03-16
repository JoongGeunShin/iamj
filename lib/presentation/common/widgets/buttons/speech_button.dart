import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../dialogs/speech_dialog.dart';

class SpeechButton extends StatelessWidget {
  final Function(String) onResult;

  const SpeechButton({super.key, required this.onResult});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // 1. 마이크 권한 상태 확인 및 요청
        var status = await Permission.microphone.status;

        if (status.isGranted) {
          // 권한이 이미 있는 경우 바로 다이얼로그 실행
          _showSpeechDialog(context);
        } else if (status.isPermanentlyDenied) {
          // 사용자가 '다시 묻지 않음'을 선택하고 거부한 경우
          _showSettingsDialog(context);
        } else {
          // 권한이 없거나 처음 요청하는 경우
          var result = await Permission.microphone.request();
          if (result.isGranted) {
            _showSpeechDialog(context);
          } else {
            // 단순 거절 시 스낵바 표시
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("음성 인식을 위해 마이크 권한이 필요합니다."),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      child: const Icon(Icons.mic),
    );
  }

  // 음성 인식 다이얼로그 띄우기 로직 분리
  void _showSpeechDialog(BuildContext context) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) => const SpeechDialog(),
    );

    if (result != null && result.isNotEmpty) {
      onResult(result);
    }
  }

  // 앱 설정으로 유도하는 안내 다이얼로그
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
              openAppSettings(); // OS 설정 화면으로 이동
              Navigator.pop(context);
            },
            child: const Text("설정으로 이동"),
          ),
        ],
      ),
    );
  }
}