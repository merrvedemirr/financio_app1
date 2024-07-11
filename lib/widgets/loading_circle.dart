import 'package:financio_app/constants/parameters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading_circle extends StatelessWidget {
  const Loading_circle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: maincolor,
        size: 50.0,
      ),
    );
  }
}
