import 'package:app/color.dart';
import 'package:flutter/material.dart';

class CharacterProgress extends StatelessWidget {
  final String? text;
  const CharacterProgress({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(30),
            child: CircularProgressIndicator(
              color: baseColor,
              strokeWidth: 8,
            ),
          ),
          Text(
            text ?? "",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
