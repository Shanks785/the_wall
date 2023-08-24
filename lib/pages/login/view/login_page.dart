import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:the_wall/components/text_field.dart';
import 'package:the_wall/components/button.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  //Text Editing Controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Sign in User
  void signIn() async {

    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),));
    try {
      var res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user found.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password.')));
      }
    }

    print(await FirebaseAuth.instance.currentUser!.getIdToken());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  const Icon(Icons.lock, size: 100,),
                    
                  const SizedBox(height: 50),
                  //wlcm back msg
                  const Text("Welcome Back!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  
                  const SizedBox(height: 25),
                  //email field
                  MyTextField(controller: emailTextController, hintText: 'Email', obscureText: false),

                  const SizedBox(height: 10),
                  //password field
                  MyTextField(controller: passwordTextController, hintText: 'Password', obscureText: true),

                  const SizedBox(height: 25),
                  //sign in button
                  MyButton(text: 'Sign In', onTap: signIn,),

                  const SizedBox(height: 25),
                  //go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?", style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Register now", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
