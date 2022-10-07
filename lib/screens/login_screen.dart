import 'package:flutter/material.dart';
import 'package:new_flash_chat/constants.dart';
import 'package:new_flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_flash_chat/screens/chat_screen.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email.',
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password.'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    colour: Colors.lightBlueAccent,
                    onPressed: () async {
                      try {
                        setState(() {
                          _isLoading = true;
                        });

                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        if (user != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }

                        setState(() {
                          _isLoading = false;
                        });
                      } catch (e) {
                        logger.e(e);
                      }
                    },
                    title: 'Log In',
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.white,
            ),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
