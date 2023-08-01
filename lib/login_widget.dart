import 'customdatabase.dart';
import 'utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedReset;
  const LoginWidget({Key? key, required this.onClickedReset})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
    body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              TextField(
                controller: emailController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              SizedBox(height: 4),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: SignIn,
                  icon: Icon(
                    Icons.lock_open,
                    size: 32,
                  ),
                  label: Text(
                    'Zaloguj się',
                    style: TextStyle(fontSize: 24),
                  )),
              SizedBox(height: 24),
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.red),
                      text: 'Zapomniałeś hasła?  ',
                      children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedReset,
                        text: 'Reset hasła',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor
                        ))
                  ])),
                    ],
          ),
        ),
  );}

  Future SignIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CustomData()));
      }
    } on FirebaseAuthException {
      Utils.showSnackBar('Błędny email lub hasło użytkownika.');
    }

  }
}
