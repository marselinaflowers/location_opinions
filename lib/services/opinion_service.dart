import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/opinion.dart';
import 'auth_service.dart';
import 'slur_filter.dart';


class OpinionService {
      	final FirebaseFirestore _firestore = FirebaseFirestore.instance;
	final String _collection = 'opinions';

  CollectionReference get _opinionsRef => _firestore.collection(_collection);
  final AuthService _authService = AuthService();
  final userId = AuthService().uid;

Future<void> createOpinion({
  required String text, 
}) async {
    if (SlurFilter.containsSlur(text)) {
      _authService.deleteCurrentUser();
      throw Exception("Don't be a dick.");    
    } 
    		final user = _authService.currentUser;  
    final author = user?.displayName ?? 'Unknown';
    final authorId = user?.uid ?? "";
    final opinion = Opinion(text: text, id: Uuid().v4(), author: author, authorId: authorId, upVotes: [authorId], downVotes: [], createdAt: DateTime.now()); 
    await _opinionsRef.doc(opinion.id).set(opinion.toMap());
}

Stream<List<Opinion>> getOpinionsStream() {
  return _opinionsRef.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Opinion.fromMap(doc.data() as Map<String, dynamic>)).toList();
  });
}

		 upvote(String opinionId) async {	
			if (userId == null) return;
		 await _opinionsRef.doc(opinionId).update({
				'upVotes': FieldValue.arrayUnion([userId]),
			});
		}
    	 unUpvote(String opinionId) async {
			if (userId == null) return;
		 await _opinionsRef.doc(opinionId).update({
				'upVotes': FieldValue.arrayRemove([userId]),
			});
		}

    	 downvote(String opinionId) async {
			if (userId == null) return;
		 await _opinionsRef.doc(opinionId).update({
				'downVotes': FieldValue.arrayUnion([userId]),
			});
		}
  unDownvote(String opinionId) async {
			if (userId == null) return;
     await _opinionsRef.doc(opinionId).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    }

    delete(String opinionId) async {
      await _opinionsRef.doc(opinionId).delete();
    }
}