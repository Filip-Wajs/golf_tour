import 'package:flutter/material.dart';
import 'login_widget.dart';
import 'reset_password.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedReset: toggle)
      : ResetPasswordPage(onClickedLogIn: toggle);
  void toggle() => setState(() => isLogin = !isLogin);

}
