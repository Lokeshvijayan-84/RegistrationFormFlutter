//aena ada pothled

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  //main
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //2
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String errorMessage = '';

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    // Validate that both email and password fields are not empty
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please enter both email and password.';
      });
      return;
    }

    // Validate the email format
    if (!EmailValidator.validate(email)) {
      setState(() {
        errorMessage = 'Invalid email format, please enter a valid email.';
      });
      return;
    }
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        // Navigate to the home page or any other authenticated page
        context.go('/');
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific exceptions
      if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = 'You are not signed up. Please sign up first.';
        });
      } else {
        // Handle login errors
        print('Error during login: $e');
        setState(() {
          errorMessage = 'Invalidpassword ,try again!';
        });
      }
    } catch (e) {
      // Handle other exceptions
      print('Error during login: $e');
      setState(() {
        errorMessage =
            'An error occurred during login. Please try again later.';
      });
    }
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      // Navigate back to the login page
      //next ?
      context.go('/signin');
    } catch (e) {
      // Handle logout errors
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
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
                  enabledBorder: const OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(),
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
                onPressed: _signIn,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
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
                  Text('Dont have an account ?'),
                  OutlinedButton(
                      onPressed: () {
                        context.go('/signup');
                      },
                      child: Text('SignUp')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
