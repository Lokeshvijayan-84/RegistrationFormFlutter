import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  //main
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isSignupSuccessful = false;
  //2
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = "";

  void _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter both email and password.';
      });
      return;
    }

    // Show an error message if email or password is empty
    //Exit the method without attempting to sign
    if (!EmailValidator.validate(email)) {
      setState(() {
        errorMessage = 'Invalid email format, please enter a valid email.';
      });
      return;
    } else {
      setState(() {
        errorMessage = "";
      });
    }

    try {
      // Validate that both email and password fields are not empty

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text, //namedparameters
      );
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // User is already signed in, show a message at the bottom
        setState(() {
          isSignupSuccessful = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup successful!'),
            duration: Duration(seconds: 5),
          ),
        ); // Exit the method without attempting to sign up
      }
      if (userCredential.user != null) {
        // Perform any additional actions pon successful signup
        context.go('/signin');  //redirect
      }
    } catch (e) {
      // Handle signup errors
      print('Error during signup: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Page'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[400],
                  foregroundColor: Colors.black,
                  fixedSize: const Size(100, 48),
                ),
                onPressed: _signUp,
                child: Text(
                  'SignUp',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 32.0),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Card(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              SizedBox(height: 32.0),
              Row(
                children: [
                  const Text('Have an account? '),
                  OutlinedButton(
                      onPressed: () {
                        context.go('/signin');
                      },
                      child: const Text('Login')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
