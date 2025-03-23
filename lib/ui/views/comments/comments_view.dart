import 'package:flutter/material.dart';

class CommentsView extends StatelessWidget {
  final int postId;
  
  const CommentsView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Center(
        child: Text('Comments for Post ID: $postId'),
      ),
    );
  }
}