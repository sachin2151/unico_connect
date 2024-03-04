import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unico_connect/models/post_model.dart';
import 'package:unico_connect/providers/post_provider.dart';
import 'package:unico_connect/view/create_post_view.dart';
import 'package:unico_connect/view/profile_view.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfileView()));
            },
            child: const Icon(Icons.person_3_outlined)),
        title: const Text('Community Posts'),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
        child: StreamBuilder<List<Post>>(
          stream: postProvider.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData && (snapshot.data ?? []).isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data?[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        height: 20,
                                        width: 20,
                                        child: const Icon(
                                          Icons.person,
                                          size: 15,
                                        )),
                                    Text(
                                      post?.userId ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(post?.content ?? "")),
                                Text(DateFormat('Hm').format(
                                    DateTime.parse(post?.timestamp ?? ""))),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }

            return const Center(
                child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text('No posts available.'),
            ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
