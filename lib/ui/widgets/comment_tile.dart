import 'package:flutter/material.dart';
import '../../models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '"${comment.text}"',
        textAlign: TextAlign.right,
        style: const TextStyle(fontStyle: FontStyle.normal),
      ),
      subtitle: Text(
        '- ${comment.author}',
        textAlign: TextAlign.right,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }
}
