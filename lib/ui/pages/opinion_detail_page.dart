// import 'dart:async';

// import 'package:flutter/material.dart';

// import '../../models/comment.dart';
// import '../../models/opinion.dart';
// import '../../services/auth_service.dart';
// import '../../services/comment_service.dart';
// import '../../services/opinion_service.dart';

// class OpinionDetailPage extends StatefulWidget {
//   final Opinion opinion;
//   const OpinionDetailPage(this.opinion, {super.key});

//   @override
//   State<OpinionDetailPage> createState() => _OpinionDetailPageState();
// }

// class _OpinionDetailPageState extends State<OpinionDetailPage> {
//   static const _holdDuration = Duration(milliseconds: 250);
//   Timer? _holdTimer;

//   bool _showOptions = false;
//   bool _showComments = false;
//   bool _showCommentInput = false;
//   Offset? _longPressStart;
//   late Opinion _opinion;
//   final _commentController = TextEditingController();
//   final _opinionService = OpinionService();
//   final _commentService = CommentService();

//   @override
//   void initState() {
//     super.initState();
//     _opinion = widget.opinion;
//   }

//   @override
//   void dispose() {
//     _holdTimer?.cancel();
//     _holdTimer = null;
//     _commentController.dispose();
//     super.dispose();
//   }

//   void _handleRelease(Offset globalPosition) {
//     if (!_showOptions || _longPressStart == null) {
//       setState(() => _showOptions = false);
//       return;
//     }
//     final dx = globalPosition.dx - _longPressStart!.dx;
//     final dy = globalPosition.dy - _longPressStart!.dy;
//     const threshold = 40.0;

//     if (dx > threshold) {
//       _opinionService.disagree(_opinion.id);
//       final uid = AuthService().uid;
//       if (uid != null) {
//         _opinion = _opinion.copyWith(
//           downVotes: [..._opinion.downVotes, uid],
//           upVotes: _opinion.upVotes.where((id) => id != uid).toList(),
//         );
//       }
//     } else if (dx < -threshold) {
//       _opinionService.agree(_opinion.id);
//       final uid = AuthService().uid;
//       if (uid != null) {
//         _opinion = _opinion.copyWith(
//           upVotes: [..._opinion.upVotes, uid],
//           downVotes: _opinion.downVotes.where((id) => id != uid).toList(),
//         );
//       }
//     } else if (dy < -threshold) {
//       setState(() {
//         _showComments = true;
//       });
//     } else if (dy > threshold) {
//       setState(() {
//         _showCommentInput = true;
//       });
//     }
//     setState(() {
//       _showOptions = false;
//       _longPressStart = null;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, _) {
//         if (!didPop) {
//           Navigator.of(context).pop(_opinion);
//         }
//       },
//       child: Scaffold(
//       appBar: AppBar(
//         title: const Text('👂💬👂💬👂💬'),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Text(
//                   _opinion.text,
//                   style: Theme.of(context).textTheme.titleLarge,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Expanded(
//                 child: Center(
//                   child: Listener(
//                     onPointerDown: (event) {
//                       _holdTimer?.cancel();
//                       _longPressStart = event.position;
//                       _holdTimer = Timer(_holdDuration, () {
//                         if (mounted) {
//                           setState(() {
//                             _showOptions = true;
//                             _showComments = false;
//                             _showCommentInput = false;
//                           });
//                         }
//                       });
//                     },
//                     onPointerUp: (event) {
//                       _holdTimer?.cancel();
//                       _holdTimer = null;
//                       if (_showOptions && _longPressStart != null) {
//                         _handleRelease(event.position);
//                       } else {
//                         _longPressStart = null;
//                       }
//                     },
//                     onPointerCancel: (_) {
//                       _holdTimer?.cancel();
//                       _holdTimer = null;
//                       setState(() {
//                         _showOptions = false;
//                         _longPressStart = null;
//                       });
//                     },
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       alignment: Alignment.center,
//                       child: const Text(
//                         'Hold',
//                         style: TextStyle(color: Colors.white, fontSize: 24),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           if (_showOptions)
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 final size = MediaQuery.of(context).size;
//                 final centerX = size.width / 2;
//                 final centerY = size.height / 2;
//                 const radius = 110.0;
//                 const bubbleRadius = 25.0;
//                 return Stack(
//                   children: [
//                     // Left: Agree
//                     Positioned(
//                       left: centerX - radius - bubbleRadius,
//                       top: centerY - bubbleRadius,
//                       child: const _OptionBubble(icon: Icons.thumb_up, label: 'Agree'),
//                     ),
//                     // Right: Disagree
//                     Positioned(
//                       left: centerX + radius - bubbleRadius,
//                       top: centerY - bubbleRadius,
//                       child: const _OptionBubble(icon: Icons.thumb_down, label: 'Disagree'),
//                     ),
//                     // Up (Comments)
//                     Positioned(
//                       left: centerX - bubbleRadius,
//                       top: centerY - radius - bubbleRadius,
//                       child: const _OptionBubble(icon: Icons.comment, label: 'Comments'),
//                     ),
//                     // Down (Add Comment)
//                     Positioned(
//                       left: centerX - bubbleRadius,
//                       top: centerY + radius - bubbleRadius,
//                       child: const _OptionBubble(icon: Icons.edit, label: 'Add Comment'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           if (_showComments)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.5,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       offset: Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 16),
//                     const Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                     const Divider(),
//                     Expanded(
//                       child: StreamBuilder<List<Comment>>(
//                         stream: _commentService.getCommentsStream(_opinion.id),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return const Center(child: CircularProgressIndicator());
//                           }
//                           if (snapshot.hasError) {
//                             return Center(child: Text('Error: ${snapshot.error}'));
//                           }
//                           final comments = snapshot.data ?? [];
//                           if (comments.isEmpty) {
//                             return const Center(child: Text('No comments yet.'));
//                           }
//                           return ListView.builder(
//                             itemCount: comments.length,
//                             itemBuilder: (context, index) {
//                               final c = comments[index];
//                               return ListTile(
//                                 title: Text(c.text),
//                                 subtitle: Text('by ${c.author}'),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           _showComments = false;
//                         });
//                       },
//                       child: const Text('Close'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           if (_showCommentInput)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       offset: Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text('Add a Comment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: _commentController,
//                       decoration: const InputDecoration(
//                         labelText: 'Your comment',
//                         border: OutlineInputBorder(),
//                       ),
//                       minLines: 2,
//                       maxLines: 4,
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             _commentController.clear();
//                             setState(() => _showCommentInput = false);
//                           },
//                           child: const Text('Cancel'),
//                         ),
//                         ElevatedButton(
//                           onPressed: () async {
//                             final text = _commentController.text.trim();
//                             if (text.isEmpty) return;
//                             try {
//                               await _commentService.saveComment(
//                                 opinionId: _opinion.id,
//                                 text: text,
//                               );
//                               _commentController.clear();
//                               setState(() => _showCommentInput = false);
//                             } catch (e) {
//                               if (mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('$e')),
//                                 );
//                               }
//                             }
//                           },
//                           child: const Text('Post'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//       ),
//     );
//   }
// }

// class _OptionBubble extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _OptionBubble({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Column(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.blue.shade100,
//             child: Icon(icon, color: Colors.blue),
//           ),
//           const SizedBox(height: 4),
//           Text(label, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }