import 'package:flutter/material.dart';
import '../../models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final bool isLikedByAuthor;
  final bool isDislikedByAuthor;
  const CommentTile({super.key, required this.comment, required this.isLikedByAuthor, required this.isDislikedByAuthor});

  @override
  Widget build(BuildContext context) {
    String? face;
    if (isLikedByAuthor) {
      face = '= )';
    } else if (isDislikedByAuthor) {
      face = '= (';
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (face != null)
                  RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      face,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 15),
                    ),
                  ),
                if (face != null) const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '"${comment.text}"',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontStyle: FontStyle.normal),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        '- ${comment.author}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}