import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unico_connect/models/post_model.dart';
import 'package:unico_connect/providers/post_provider.dart';

class CreatePostScreen extends StatelessWidget {
  final TextEditingController _postController = TextEditingController();

  CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Post Content',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final userId = FirebaseAuth.instance.currentUser?.email ?? "";
                final content = _postController.text;
                final timestamp = DateTime.now().toString();

                final post = Post(
                    userId: userId, content: content, timestamp: timestamp);
                await postProvider.addPost(post);

                Navigator.pop(context);
              },
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
