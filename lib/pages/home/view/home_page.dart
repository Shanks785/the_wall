import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:the_wall/components/text_field.dart';

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
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // post MSG
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        controller: textController,
                        hintText: "What's on your mind?", obscureText: false,
                      )
                    ),
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
