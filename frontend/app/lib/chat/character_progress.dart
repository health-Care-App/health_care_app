import 'package:app/color.dart';
import 'package:flutter/material.dart';

class CharacterProgress extends StatelessWidget {
  const CharacterProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 100,
      heightFactor: 100,
      child: SizedBox(
        width: 80,
        height: 80,
        child: CircularProgressIndicator(
          color: pinkColor,
          strokeWidth: 8,
        ),
      ),
    );
  }
}
