//*Particle Widget.
import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';

class Circular_Particle extends StatelessWidget {
  const Circular_Particle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularParticle(
      key: UniqueKey(),
      awayRadius: 50,
      numberOfParticles: 400,
      speedOfParticles: 1,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      onTapAnimation: false,
      particleColor: Colors.blue.withAlpha(20),
      awayAnimationDuration: Duration(milliseconds: 600),
      maxParticleSize: 0,
      isRandSize: true,
      isRandomColor: true,
      randColorList: [
        Colors.white.withAlpha(210),
      ],
      awayAnimationCurve: Curves.easeOutCirc,
      enableHover: true,
      hoverColor: Colors.white,
      hoverRadius: 90,
      connectDots: true, //not recommended
    );
  }
}
