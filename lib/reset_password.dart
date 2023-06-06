import 'package:email_validator/email_validator.dart';
import 'utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  final Function() onClickedLogIn;
  const ResetPasswordPage({Key? key, required this.onClickedLogIn}) : super(key: key);

  @override
  _ResetPasswordPage createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  //final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
   // passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Wyśli wiadomość e-mail resetującą hasło użytkownika.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),),
          SizedBox(height: 20),
          SizedBox(height: 40),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'E-mail'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) => email != null && !EmailValidator.validate(email)
            ? 'Wprowadź poprawny e-mail'
            : null,
          ),
          SizedBox(height: 4),
          // TextFormField(
          //   controller: passwordController,
          //   textInputAction: TextInputAction.done,
          //   decoration: InputDecoration(labelText: 'Password'),
          //   obscureText: true,
          //   autovalidateMode: AutovalidateMode.onUserInteraction,
          //   validator: (value) => value != null && value.length < 6
          //   ? 'Wpisz min. 6 zmaków'
          //   : null,
          // ),
          SizedBox(height: 20),
          ElevatedButton.icon(onPressed: resetPassword,
              icon: Icon(Icons.lock_open, size: 32,), label: Text('Resetuj hasło', style: TextStyle(fontSize: 24),)),

          SizedBox(height: 24),
          RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.red),
                  text: 'Wróć do strony:  ',
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedLogIn,
                        text: 'Logowanie',
                        style: TextStyle(decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor)
                    )
                  ]
              )
          )

        ],
      ),
    ),
  );

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),)
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Hasło zostało zresetowane');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }

  // Future SignUp() async {
  //   final isValid = formKey.currentState!.validate();
  //   if (!isValid) return;
  //   try {
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text.trim(),
  //         password: passwordController.text.trim()
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     print(e);
  //     Utils.showSnackBar(e.message);
  //   }
  // }

}
