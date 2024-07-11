import 'package:financio_app/widgets/loading_circle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '/views/home.dart';
import '/constants/parameters.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String initialCountry = 'TR';
  PhoneNumber number = PhoneNumber(isoCode: 'TR');

  String _verificationId = '';
  bool _isCodeSent = false;

  void _verifyPhone() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Loading_circle();
      },
    );
    await _auth.verifyPhoneNumber(
      phoneNumber: number.phoneNumber.toString(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.pop(context);
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Geçersiz telefon numarası.')),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pop(context);

        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Navigator.pop(context);

        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _signInWithPhoneNumber() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: SpinKitFadingCircle(
            color: maincolor,
            size: 50.0,
          ),
        );
      },
    );
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _codeController.text,
      );

      await _auth.signInWithCredential(credential).then((value) async {
        DocumentSnapshot documentSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(number.phoneNumber).get();

        if (documentSnapshot.exists) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
        } else {
          Navigator.pop(context);
          final TextEditingController firstNameController = TextEditingController();
          final TextEditingController lastNameController = TextEditingController();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text('Bilgilerinizi Girin'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(labelText: 'İsim'),
                    ),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Soyisim'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('İptal'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String firstName = firstNameController.text;
                      String lastName = lastNameController.text;
                      print(firstName);
                      print(lastName);
                      print(number.phoneNumber);

                      if (firstName.isNotEmpty && lastName.isNotEmpty) {
                        await FirebaseFirestore.instance.collection('users').doc(number.phoneNumber).set({
                          'firstName': firstName,
                          'lastName': lastName,
                        });

                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                      } else {
                        // Zorunlu alanlar için bir uyarı gösterebiliriz
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
                        );
                      }
                    },
                    child: const Text('Kaydet'),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doğrulama kodu hatalı.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: Image.asset("assets/logo.png"),
              ),
              const Text(
                'Telefon Numarası ile Giriş Yap',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              InternationalPhoneNumberInput(
                hintText: "Telefon No",
                onInputChanged: (PhoneNumber value) {
                  setState(() {
                    number = value;
                  });
                },
                onInputValidated: (bool value) {},
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(color: Colors.white),
                initialValue: number,
                textFieldController: _phoneController,
                formatInput: true,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                inputBorder: const OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  // print('On Saved: $number');
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifyPhone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Telefonu Doğrula',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              if (_isCodeSent) ...[
                const SizedBox(height: 32),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  textStyle: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  onChanged: (value) {
                    _codeController.text = value;
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 60,
                    activeColor: maincolor,
                    inactiveColor: Colors.grey,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signInWithPhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Giriş Yap',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
