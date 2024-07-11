import 'package:financio_app/auth/login.dart';
import 'package:financio_app/constants/parameters.dart';
import 'package:financio_app/views/Login/register_screen.dart';
import 'package:financio_app/widgets/circular_particle.dart';
import 'package:flutter/material.dart';

class IsLogin extends StatefulWidget {
  const IsLogin({super.key});

  @override
  State<IsLogin> createState() => _IsLoginState();
}

class _IsLoginState extends State<IsLogin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              const Circular_Particle(),
              Center(
                child: Column(
                  children: [
                    Expanded(flex: 5, child: Container(width: 300, child: Image.asset("assets/logo.png"))),
                    Expanded(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //giris yap
                            LoadingButton(
                              title: "Giriş Yap",
                              onPressed: () async {
                                await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PhoneAuthScreen(),
                                ));
                              },
                            ),
                            //kayıt ol
                            LoadingButton(
                              title: "Kayıt Ol",
                              onPressed: () async {
                                await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ));
                              },
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class Custom_Button extends StatefulWidget {
  const Custom_Button({
    super.key,
    required this.onPress,
    required this.message,
  });
  final void Function()? onPress;
  final String message;
  @override
  State<Custom_Button> createState() => _Custom_ButtonState();
}

class _Custom_ButtonState extends State<Custom_Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => maincolor),
              padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.11))),
          onPressed: () {
            widget.onPress;
          },
          child: Text(
            widget.message,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          )),
    );
  }
}

/******* */

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key, required this.title, required this.onPressed});
  final String title;
  final Future<void> Function()
      onPressed; //*Loading işlemini beklemesi lazım ve Servis işlemi olduğu için Future yaptık
  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

//! bu yöntem ile adamın vereceği servisi bekleyip yüklenme olaylarını gösteriyoruz.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => maincolor),
              padding: MaterialStateProperty.resolveWith(
                  (states) => EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.11))),
          onPressed: () async {
            if (_isLoading) return;
            _changeLoading();
            await widget.onPressed.call();
            _changeLoading();
          },
          child: _isLoading
              ? CircularProgressIndicator()
              : Text(
                  widget.title,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                )),
    );
  }
}
