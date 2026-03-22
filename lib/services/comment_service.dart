import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/comment.dart';
import 'auth_service.dart';
import 'slur_filter.dart';

/// Comments are stored as a subcollection of each opinion:
/// opinions/{opinionId}/comments/{userId}
/// Using userId as the document ID guarantees one comment per user per opinion.
class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  CollectionReference<Map<String, dynamic>> _commentsRef(String opinionId) =>
      _firestore.collection('opinions').doc(opinionId).collection('comments');

  /// Save or update the current user's comment. Document ID = userId.
  Future<void> saveComment({
    required String opinionId,
    required String text,
  }) async {
    if (SlurFilter.containsSlur(text)) {
      _authService.deleteCurrentUser();
      throw Exception("Don't be a dick.");
    }
    final user = _authService.currentUser;
    if (user == null) return;

    final comment = Comment(
      userId: user.uid,
      author: user.displayName ?? 'Unknown',
      text: text,
      createdAt: DateTime.now(),
    );
    await _commentsRef(opinionId).doc(user.uid).set(comment.toMap());
  }

  /// Stream of comments for an opinion, ordered by createdAt.
  Stream<List<Comment>> getCommentsStream(String opinionId) {
    return _commentsRef(opinionId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Comment.fromMap(doc.data()))
          .toList();
    });
  }

  /// Get the current user's comment for an opinion, if any.
  Future<Comment?> getMyComment(String opinionId) async {
    final uid = _authService.uid;
    if (uid == null) return null;

    final doc = await _commentsRef(opinionId).doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return Comment.fromMap(doc.data()!);
    }
    return null;
  }
}
