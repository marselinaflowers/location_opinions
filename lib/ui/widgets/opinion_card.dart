import 'package:flutter/material.dart';
import 'package:location_opinions/models/opinion.dart';
import 'package:location_opinions/ui/pages/opinion_comments_page.dart';
import '../../services/auth_service.dart';
import '../../services/opinion_service.dart';

class OpinionCard extends StatelessWidget {
  final Opinion opinion;

  const OpinionCard(this.opinion, {super.key});

  @override
  Widget build(BuildContext context) {
        final auth = AuthService();
        final uid = auth.uid;
        final hasUpvoted = uid != null && opinion.upVotes.contains(uid);
        final hasDownvoted = uid != null && opinion.downVotes.contains(uid);
        final user = auth.currentUser;
        final isAuthor = user != null && user.uid == opinion.authorId;
        final opinionService = OpinionService();
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OpinionCommentsPage(opinion),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: hasUpvoted
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vote buttons on the left
              if (!(hasUpvoted || hasDownvoted)) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      tooltip: 'Upvote',
                      onPressed: () async {
                        await opinionService.upvote(opinion.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      tooltip: 'Downvote',
                      onPressed: () async {
                        await opinionService.downvote(opinion.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: hasUpvoted
                      ? const RotatedBox(
                          quarterTurns: 1,
                          child: Text('= )', style: TextStyle(fontSize: 28, fontFamily: 'monospace')),
                        )
                      : hasDownvoted
                          ? const RotatedBox(
                              quarterTurns: 1,
                              child: Text('= (', style: TextStyle(fontSize: 28, fontFamily: 'monospace')),
                            )
                          : const SizedBox(width: 32),
                ),
              ],
              // Opinion content (right-aligned)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      opinion.text,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${opinion.author}',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Delete button (if author)
              if (isAuthor)
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete Topic',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Topic'),
                        content: const Text('Are you sure you want to delete this topic? This cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await opinionService.delete(opinion.id);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}