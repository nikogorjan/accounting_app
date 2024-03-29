import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'objekti/hive_global.dart';
import 'zasloni/screens.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:accounting_app/data/data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  box = await Hive.openBox('box');
  Hive.registerAdapter(HiveGlobalAdapter());

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBk4KYX4VuGcxZqa7L9-ShS02k4yHPi5qk",
            authDomain: "accountingapp-3eb0d.firebaseapp.com",
            projectId: "accountingapp-3eb0d",
            storageBucket: "accountingapp-3eb0d.appspot.com",
            messagingSenderId: "912614668231",
            appId: "1:912614668231:web:0b742e7168fd026f038be2",
            measurementId: "G-HLYYLP033G"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
    );
  }
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreenMobile(),
    );
  }
}
