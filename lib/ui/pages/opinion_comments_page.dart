import 'package:flutter/material.dart';

import '../../models/comment.dart';
import '../../models/opinion.dart';
import '../../services/auth_service.dart';
import '../../services/comment_service.dart';
import '../../services/opinion_service.dart';
import '../widgets/comment_tile.dart';


class OpinionCommentsPage extends StatefulWidget {
  final Opinion opinion;
  const OpinionCommentsPage(this.opinion, {super.key});

  @override
  State<OpinionCommentsPage> createState() => _OpinionCommentsPageState();
}

class _OpinionCommentsPageState extends State<OpinionCommentsPage> {
  final _commentController = TextEditingController();
  final _opinionService = OpinionService();
  final _commentService = CommentService();
  late Opinion _opinion;

  @override
  void initState() {
    super.initState();
    _opinion = widget.opinion;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool get _hasUpvoted {
    final uid = AuthService().uid;
    return uid != null && _opinion.upVotes.contains(uid);
  }

  bool get _hasDownvoted {
    final uid = AuthService().uid;
    return uid != null && _opinion.downVotes.contains(uid);
  }

  bool get _hasVoted => _hasUpvoted || _hasDownvoted;

  void _showAddCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add a Comment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Your comment',
                  border: OutlineInputBorder(),
                ),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _commentController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final text = _commentController.text.trim();
                      if (text.isEmpty) return;
                      try {
                        await _commentService.saveComment(
                          opinionId: _opinion.id,
                          text: text,
                        );
                        _commentController.clear();
                        if (context.mounted) Navigator.pop(context);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$e')),
                          );
                        }
                      }
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMenuSelected(dynamic value) async {
    if (value == 'comment') {
      _showAddCommentSheet();
    } else if (value == 'undo_vote') {
      if (_hasUpvoted) {
        await _opinionService.unUpvote(_opinion.id);
      } else {
        await _opinionService.unDownvote(_opinion.id);
      }
      if (mounted) setState(() {});
    } else if (value == 'agree') {
      await _opinionService.agree(_opinion.id);
      if (mounted) setState(() {});
    } else if (value == 'disagree') {
      await _opinionService.disagree(_opinion.id);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = <PopupMenuEntry<dynamic>>[
      const PopupMenuItem(
        value: 'comment',
        child: ListTile(
          leading: Icon(Icons.comment),
          title: Text('Comment'),
          contentPadding: EdgeInsets.zero,
        ),
      ),
      if (_hasVoted)
        const PopupMenuItem(
          value: 'undo_vote',
          child: ListTile(
            leading: Icon(Icons.undo),
            title: Text('Undo vote'),
            contentPadding: EdgeInsets.zero,
          ),
        )
      else ...[
        const PopupMenuItem(
          value: 'agree',
          child: ListTile(
            leading: Icon(Icons.thumb_up),
            title: Text('Agree'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'disagree',
          child: ListTile(
            leading: Icon(Icons.thumb_down),
            title: Text('Disagree'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      //DISIMPLEMENTED FEATURE - VOTE BY HOLDING
      // const PopupMenuItem(
      //   value: 'vote',
      //   child: ListTile(
      //     leading: Icon(Icons.touch_app),
      //     title: Text('Vote (hold & release)'),
      //     contentPadding: EdgeInsets.zero,
      //   ),
      // ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        actions: [
          PopupMenuButton<dynamic>(
            icon: const Icon(Icons.more_vert),
            onSelected: _onMenuSelected,
            itemBuilder: (context) => menuItems,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _opinion.text,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: _commentService.getCommentsStream(_opinion.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                }
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    return CommentTile(comment: c);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
