import 'package:flutter/material.dart';

import '../../models/opinion.dart';

class OpinionDetailPage extends StatefulWidget {
  final Opinion opinion;
  const OpinionDetailPage(this.opinion, {super.key});

  @override
  State<OpinionDetailPage> createState() => _OpinionDetailPageState();

class _OpinionDetailPageState extends State<OpinionDetailPage> {
  bool _showOptions = false;
  bool _showComments = false;
  bool _showCommentInput = false;

  void _onPanUpdate(DragUpdateDetails details) {
    final dx = details.delta.dx;
    final dy = details.delta.dy;
    if (_showOptions) {
      if (dx > 10) {
        // Like
        setState(() {
  class _OpinionDetailPageState extends State<OpinionDetailPage> {
        });
        // TODO: Like logic
      } else if (dx < -10) {
        // Dislike
        setState(() {
          _showOptions = false;
        });
        // TODO: Dislike logic
      } else if (dy < -10) {
        // Up: Show comments
        setState(() {
      }

          _showOptions = false;
        });
      } else if (dy > 10) {
        // Down: Show comment input
        setState(() {
          _showCommentInput = true;
          _showOptions = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👂💬👂💬👂💬'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onLongPressStart: (_) {
                setState(() {
                  _showOptions = true;
                  _showComments = false;
                  _showCommentInput = false;
                });
              },
              onLongPressEnd: (_) {
                setState(() {
                  _showOptions = false;
                });
              },
              onPanUpdate: _onPanUpdate,
  class _OptionBubble extends StatelessWidget {
    final IconData icon;
    final String label;
    const _OptionBubble({required this.icon, required this.label});

    @override
    Widget build(BuildContext context) {
      return Material(
        color: Colors.transparent,
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
    }
  }
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Hold',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
          if (_showOptions) ...[
            // Right (Like)
            Positioned(
              right: 40,
              top: MediaQuery.of(context).size.height / 2 - 25,
              child: const _OptionBubble(icon: Icons.thumb_up, label: 'Like'),
            ),
            // Left (Dislike)
            Positioned(
              left: 40,
              top: MediaQuery.of(context).size.height / 2 - 25,
              child: const _OptionBubble(icon: Icons.thumb_down, label: 'Dislike'),
            ),
            // Up (Comments)
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 25,
              top: 100,
              child: const _OptionBubble(icon: Icons.comment, label: 'Comments'),
            ),
            // Down (Add Comment)
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 25,
              bottom: 100,
              child: const _OptionBubble(icon: Icons.edit, label: 'Add Comment'),
            ),
          ],
          if (_showComments)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 5, // TODO: Replace with real comments
                        itemBuilder: (context, index) => ListTile(
                          title: Text('Comment #$index'),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showComments = false;
                        });
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          if (_showCommentInput)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Add a Comment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
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
                            setState(() {
                              _showCommentInput = false;
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Save comment
                            setState(() {
                              _showCommentInput = false;
                            });
                          },
                          child: const Text('Post'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionBubble extends StatelessWidget {
  final IconData icon;
  final String label;
  const _OptionBubble({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
}