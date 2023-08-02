import '../pages/edit.dart';
import '../pages/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/login.dart';
import '../pages/registration.dart';
import '../pages/error_page.dart';
import '../pages/show.dart';
import '../pages/signup.dart';
import 'app_route_constants.dart';

class MyRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: MyRouterConstants.homeRouteName,
        pageBuilder: (context, state) {
          return  MaterialPage(child: Home()); 
        },
      ),
      GoRoute(
        path: '/registration',
        name: MyRouterConstants.registerRouteName,
        pageBuilder: (context, state) {
          return const MaterialPage(child: Registration());
        },
      ),
      GoRoute(
        path: '/show',
        name: MyRouterConstants.showRouteName,
        pageBuilder: (context, state) {
          return const MaterialPage(child: Front());
        },
      ),
      GoRoute(
        path: '/edit/:documentId',
        name: MyRouterConstants.editRouteName,
        pageBuilder: (context, state) {
          return MaterialPage(child: Edit(state.pathParameters['documentId']));
        },
      ),
      GoRoute(
        path: '/signin',
        name: 'signin',
        pageBuilder: (context, state) {
          return const MaterialPage(child:LoginPage());
        },
      ),

      GoRoute(
        path: '/signup',   //paths ki small vadadam  text ki camilcase
        name: 'signup',
        pageBuilder: (context, state) {
          return const MaterialPage(child:SignUp());
        },
      ),
      //signup ki ?
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: Error());
    },
  );
}
