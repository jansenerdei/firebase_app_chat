import 'package:firebaseapp/models/text_model.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  final TextModel textModel;
  final bool myMessage;
  const ChatWidget(
      {super.key, required this.textModel, required this.myMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: myMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: myMessage ? Colors.blue : Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              textModel.nickname,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              textModel.text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
