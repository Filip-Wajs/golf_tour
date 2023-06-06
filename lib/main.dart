import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_tour/add_user.dart';
import 'firebase_options.dart';
import 'utils.dart';
import 'ath_page.dart';
import 'customdatabase.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf Tour',
      theme: ThemeData(primarySwatch: Colors.blue,),
      scaffoldMessengerKey: Utils.messengerKey,
      //navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      //CustomData(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            return CustomData();
          }
          else {
            return AuthPage();
          }
        }
    ),
  );

}