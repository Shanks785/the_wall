import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:the_wall/components/drawer.dart';
import 'package:the_wall/components/text_field.dart';
import 'package:the_wall/pages/home/components/wall_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controllers
  final textController = TextEditingController();

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void postMessage() async {
    print(textController.text);
    if (textController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('messages').add({
        'Message': textController.text,
        'UserEmail': currentUser.email,
        'TimeStamp': DateTime.now(),
        'Likes': [],
      });
      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("The Wall"),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // the wall
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading...");
                  }

                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return WallPost(
                            message: post['Message'],
                            user: post['UserEmail'],
                            time: '12/12/23',
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text('Error:${snapshot.error}');
                  } else {
                    return const Center(
                      child: Text("No data found")
                    );
                  }
                },
              )),

              // post MSG
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Expanded(
                        child: MyTextField(
                      controller: textController,
                      hintText: "What's on your mind?",
                      obscureText: false,
                    )),
                    IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
              //email
              Text("Logged in as: " + currentUser.email!),
            ],
          ),
        ),
      ),
    );
  }
}
