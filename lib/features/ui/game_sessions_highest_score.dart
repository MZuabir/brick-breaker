
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameHighestScore extends StatefulWidget {
  const GameHighestScore({super.key});

  @override
  State<GameHighestScore> createState() => _GameHighestScoreState();
}

class _GameHighestScoreState extends State<GameHighestScore> {
  String score = '0';
  @override
  void initState() {
    super.initState();

    getScore();
  }

  getScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('score');

    setState(() {
      score = data ?? '0';
    });
  }

  @override
  Widget build(BuildContext context) {

    return Text(
      score,
      style: const TextStyle(
        fontSize: 30,
      ),
    );
  }
}

// class GameHighestScore extends ConsumerWidget {
//   const GameHighestScore({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return FutureBuilder(
//       future: ref.read(gameSessionsControllerProvider.notifier).getScore(),
//       builder: (context, snapshot) {
//         Future<String?> data =
//             ref.read(gameSessionsControllerProvider.notifier).getScore();

        // return Text(
        //   data as String,
        //   style: const TextStyle(
        //     fontSize: 30,
        //   ),
        // );
//       },
//     );
//   }
// }
