// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:brick_breaker/modals/user_model.dart';
import 'package:brick_breaker/widgets/game_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Lottie.asset('assets/lottie/gradient.json',
                fit: BoxFit.cover, height: double.infinity),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/ball.png",
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Brick Breaker",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      const Text(
                        "Login to Brick Breaker",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              try {
                                setState(() {
                                  isLogin = true;
                                });

                                final GoogleSignInAccount? googleUser =
                                    await GoogleSignIn().signIn();
                                if (googleUser == null) {
                                  setState(() {
                                    isLogin = false;
                                  });
                                  return;
                                }

                                final GoogleSignInAuthentication googleAuth =
                                    await googleUser.authentication;

                                final credential =
                                    GoogleAuthProvider.credential(
                                  accessToken: googleAuth.accessToken,
                                  idToken: googleAuth.idToken,
                                );

                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);

                                setState(() {
                                  isLogin = false;
                                });
                                var userSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(FirebaseAuth
                                        .instance.currentUser?.email)
                                    .get();

                                if (!userSnapshot.exists) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.email)
                                      .set(UserModel(
                                              name: FirebaseAuth.instance
                                                  .currentUser?.displayName,
                                              profile: FirebaseAuth.instance
                                                  .currentUser?.photoURL,
                                              score: '0')
                                          .toJson());
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const GamePage(title: "Game"))));
                              } on FirebaseAuthException catch (e, s) {
                                setState(() {
                                  isLogin = false;
                                });
                                log(e.toString());
                              }
                            },
                            child: isLogin
                                ? const CircularProgressIndicator(
                                    color: Colors.cyan)
                                : SvgPicture.asset("assets/svg/google.svg")),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
