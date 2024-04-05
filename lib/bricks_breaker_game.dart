import 'package:brick_breaker/login_screen.dart';
import 'package:brick_breaker/widgets/game_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BricksBreakerGame extends StatelessWidget {
  const BricksBreakerGame({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bricks Breaker",
      theme: ThemeData.dark(),
      home: getScreen(),
    );
  }
}

Widget getScreen(){
  if(FirebaseAuth.instance.currentUser?.email?.isEmpty??true){
    return const LoginScreen();
  }else{
    return const GamePage(title: "Bricks Breaker");
  }
}
