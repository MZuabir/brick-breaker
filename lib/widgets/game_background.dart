import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_lottie/flame_lottie.dart';

class Background extends Component {
  late LottieComponent lottie;

  @override
  Future<void> onLoad() async {
   
    final lottieAnimation = await loadLottie(
      Lottie.asset('assets/lottie/gradient.json'),
    );
    lottie = LottieComponent(
      lottieAnimation,
      repeating: true,
    );
  }

  @override
  void render(Canvas canvas) {
    lottie.render(canvas);
  }

  @override
  void update(double dt) {
    lottie.update(dt);
  }
}
