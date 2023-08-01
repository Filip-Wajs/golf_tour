import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:golf_tour/tournaments.dart';
import 'firebase_options.dart';
import 'utils.dart';
import 'ath_page.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: Utils.messengerKey,
        builder: (context, child) {
          return Navigator(
            initialRoute: "/",
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(builder: (_) => const
                    Tournaments());
                //AuthPage());
              }
              return null; // Let `onUnknownRoute` handle this behavior.
            },
          );
        });
  }
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Golf Tour',
  //     theme: ThemeData(primarySwatch: Colors.blue,),
  //     scaffoldMessengerKey: Utils.messengerKey,
  //     debugShowCheckedModeBanner: false,
  //     builder: (context, child) => const MaterialApp(home: AuthPage()),
  //        );
  // }
}