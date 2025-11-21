import 'package:flutter/material.dart';

class RichTextTest extends StatelessWidget {
  const RichTextTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RichText 예시")),
      body: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 18, color: Colors.black),
            children: [
              TextSpan(text: "좋아요 "),
              WidgetSpan(
                child: Icon(Icons.favorite, color: Colors.red, size: 20),
              ),
              TextSpan(text: " 댓글 "),
              WidgetSpan(
                child: Icon(Icons.comment, color: Colors.blue, size: 20),
              ),
              TextSpan(text: " 공유 "),
              WidgetSpan(
                child: Icon(Icons.share, color: Colors.green, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}