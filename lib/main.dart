import 'package:amplify_api/amplify_api.dart';
import 'package:brick_breaker/bloc/inventory_bloc/inventory_bloc.dart';
import 'package:brick_breaker/bricks_breaker_game.dart';
import 'package:brick_breaker/modals/modal_provider.dart';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   await _configureAmplify();
  // } on AmplifyAlreadyConfiguredException {
  //   debugPrint('Amplify configuration failed.');
  // }

  FlameAudio.bgm.initialize();
  FlameAudio.bgm.play("bg_sound.mp3", volume: 20);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<InventoryBloc>(create: (_) => InventoryBloc()),
      ],
      child: const ProviderScope(
        child: BricksBreakerGame(),
      ),
    ),
  );
}

Future<void> _configureAmplify() async {
  await Amplify.addPlugins([
    AmplifyAuthCognito(),
    AmplifyAPI(modelProvider: ModelProvider.instance),
  ]);
  await Amplify.configure("");
}
