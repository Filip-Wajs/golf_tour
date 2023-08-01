// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'utils.dart';
//
// class AddUser extends StatefulWidget {
//
//   @override
//   State<AddUser> createState() => _AddUserState();
// }
//
// class _AddUserState extends State<AddUser> {
//   final formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   @override
//   void dispose(){
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//     padding: EdgeInsets.all(16),
//     child: Form(
//       key: formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: 40),
//           TextFormField(
//             controller: emailController,
//             cursorColor: Colors.black,
//             textInputAction: TextInputAction.next,
//             decoration: InputDecoration(labelText: 'E-mail'),
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: (email) => email != null && !EmailValidator.validate(email)
//                 ? 'Wprowadź poprawny e-mail'
//                 : null,
//           ),
//           SizedBox(height: 4),
//           TextFormField(
//             controller: passwordController,
//             textInputAction: TextInputAction.done,
//             decoration: InputDecoration(labelText: 'Hasło'),
//             obscureText: true,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: (value) => value != null && value.length < 6
//                 ? 'Wpisz min. 6 znaków'
//                 : null,
//           ),
//           SizedBox(height: 20),
//           ElevatedButton.icon(onPressed: SignUp,
//               icon: Icon(Icons.lock_open, size: 32,), label: Text('Dodaj użytkowika', style: TextStyle(fontSize: 24),)),
//
//           SizedBox(height: 24),
//
//           ElevatedButton.icon(onPressed: Delete,
//               icon: Icon(Icons.delete, size: 32,), label: Text('Usuń użytkowika', style: TextStyle(fontSize: 24),)),
//          ],
//       ),
//     ),
//   );
//
//   Future SignUp() async {
//     final isValid = formKey.currentState!.validate();
//     if (!isValid) return;
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim()
//       );
//     } on FirebaseAuthException catch (e) {
//       Utils.showSnackBar(e.message);
//     }
//   }
//   Future Delete() async {
//     final isValid = formKey.currentState!.validate();
//     if (!isValid) return;
//     try {
//       await FirebaseAuth.instance.currentUser?.delete();
//     } on FirebaseAuthException catch (e) {
//       Utils.showSnackBar(e.message);
//     }
//   }
// }
