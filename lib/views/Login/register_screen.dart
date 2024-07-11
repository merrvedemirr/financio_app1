import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financio_app/views/Login/person_profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');
  String _verificationId = '';
  String _smsCode = '';

  Widget _buildText(
      String text, String hintText, TextEditingController controller, IconData iconData, TextInputType keybordType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.next,
              keyboardType: keybordType,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    iconData,
                    color: Colors.white,
                  ),
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                    fontFamily: 'OpenSans',
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPhoneNumberField(String text, PhoneNumber number, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber value) {
                setState(() {
                  number = value;
                });
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              initialValue: number,
              textFieldController: controller,
              formatInput: true,
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
              inputDecoration: InputDecoration(
                  border: InputBorder.none,
                  //contentPadding: const EdgeInsets.only(horizontal: 3),
                  hintText: text,
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                    fontFamily: 'OpenSans',
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => const Color.fromARGB(255, 8, 84, 177)),
            padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.all(15.0)),
            shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ))),
        onPressed: () {
          //!KONTROLLER BURADA YAPILACAK
          _register();
        },
        child: const Text(
          'Giriş Yap',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

/***burdan */
  void _register() {
    //!Boş olma kontrolü
    if (_nameController.text.isNotEmpty &&
        _surnameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _emailController.text.contains("@") &&
        _phoneController.text.isNotEmpty) {
      _verifyPhone();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm alanları eksiksiz doldurunuz.'),
        ),
      );
    }
  }

  Future<void> _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInWithPhoneCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Failed to verify phone number: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        _showSmsCodeDialog();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _showSmsCodeDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('SMS Kodunu Giriniz'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _smsCode = value;
              });
            },
          ),
          actions: [
            TextButton(
              child: Text('Gönder'),
              onPressed: () async {
                Navigator.of(context).pop();
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: _verificationId,
                  smsCode: _smsCode,
                );
                await _signInWithPhoneCredential(credential);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _signInWithPhoneCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Kullanıcı bilgilerini Firestore'a kaydetme
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'firstName': _nameController.text,
        'lastName': _surnameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });

      // Kullanıcı kayıt başarılı
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in: $e');
    }
  }

/***!Buraya */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 140, 190, 252),
              Color(0xFF61A4F1),
              Color(0xFF478DE0),
              Color(0xFF398AE5),
            ], stops: [
              0.1,
              0.4,
              0.7,
              0.9
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: _TitleText(),
                  ),
                  _buildText("Ad", "Adınızı Giriniz", _nameController, Icons.person, TextInputType.name),
                  _buildText("Soyad", "Soyadınızı Giriniz", _surnameController, Icons.person, TextInputType.name),
                  _buildText("Email", "example@example.com", _emailController, Icons.email, TextInputType.emailAddress),
                  //****NUMBERR */
                  _buildPhoneNumberField("Telefon No", number, _phoneController),
                  _buildLoginBtn(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Aramıza Hoşgeldin!",
      style: TextStyle(color: Colors.white, fontFamily: "OpenSans", fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }
}
