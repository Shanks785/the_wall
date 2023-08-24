import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:the_wall/components/text_field.dart';
import 'package:the_wall/components/button.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text Editing Controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // Sign up user
  void signUp() async {

    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),));

    if(passwordTextController.text != confirmPasswordTextController.text){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    try {
      var res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text, password: confirmPasswordTextController.text);
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code)));
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
                    
                  const SizedBox(height: 45),
                  //wlcm back msg
                  const Text("Lets create an account for you", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  
                  const SizedBox(height: 25),
                  //email field
                  MyTextField(controller: emailTextController, hintText: 'Email', obscureText: false),

                  const SizedBox(height: 10),
                  //password field
                  MyTextField(controller: passwordTextController, hintText: 'Password', obscureText: true),
                  
                  const SizedBox(height: 10),
                  //Confirm password field
                  MyTextField(controller: confirmPasswordTextController, hintText: 'Confirm Password', obscureText: true),

                  const SizedBox(height: 25),
                  //sign in button
                  MyButton(text: 'Sign Up', onTap: signUp,),

                  const SizedBox(height: 25),
                  //go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Login now", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
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