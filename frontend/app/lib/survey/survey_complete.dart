import 'package:flutter/material.dart';
import 'package:app/chat/chat_screen.dart';
import 'package:app/color.dart';

class SurveyCompleteScreen extends StatelessWidget {
  const SurveyCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'おつかれさまでした！',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: surveyTextColor,
              ),
            ),
            Image.asset(
              'assets/images/survey_check.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                minimumSize: const Size(200, 70),
                backgroundColor: baseColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'チャット画面へ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
