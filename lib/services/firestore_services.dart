import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unico_connect/models/post_model.dart';

class FirestoreServices {
  final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts');
  Future<void> addPost(Post post) async {
    await _postsRef.add({
      'userId': post.userId,
      'content': post.content,
      'timestamp': post.timestamp,
    });
  }

  Stream<List<Post>> getPosts() {
    return _postsRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<dynamic, dynamic>;
              log(data.toString());
              return Post(
                userId: data['userId'],
                content: data['content'],
                timestamp: data['timestamp'],
              );
            }).toList());
  }
}
