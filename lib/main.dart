import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "../utils/app_route_config.dart";
import "package:flutter/material.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyA10-VDbpBjLAUbiLgqNPfZSOW9tQjA60Q",
        authDomain: "intellecto-notes.firebaseapp.com",
        projectId: "intellecto-notes",
        storageBucket: "intellecto-notes.appspot.com",
        messagingSenderId: "738054975017",
        appId: "1:738054975017:web:38c6bef41780ea269bf638"
    ),
  );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: MyRouter().router,
    );
  }
}
