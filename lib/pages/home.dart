import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intellimindz/pages/login.dart';
import 'package:intellimindz/pages/signup.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget page() {
    //return  _auth.currentUser == null ?const LoginPage(): const HomePage();
    if (_auth.currentUser != null) {
      return (const HomePage());
    }
    return (const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: page(),   //main execution starts from here
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEE, MMM d').format(DateTime.now());
    String currentTime = DateFormat('HH:mm').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Client details'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/signin'); // This pops the current route and goes back
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/first.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 17),
              child: Column(children: [
                Image.asset('assets/images/intellecto.png'),
                //SizedBox(height:26),
                Text(
                  currentTime,
                  style: TextStyle(fontSize: 50, color: Colors.grey[900]),
                ),
                Text(
                  currentDate,
                  style: TextStyle(fontSize: 30, color: Colors.grey[900]),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ElevatedButton(
                onPressed: () {
                  // GoRouter.of(context)
                  //     .push(Uri(path: '/registration').toString());
                  context.go('/show');
                  //ok running

                  // Navigator.of(context).push(MaterialPageRoute(builder:
                  //     (BuildContext context) => const Registration()));
                  //Navigator.of(context, rootNavigator: true).pushNamed("/registration");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
