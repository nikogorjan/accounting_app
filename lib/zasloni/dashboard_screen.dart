import 'package:accounting_app/gradniki/responsive.dart';
import 'package:accounting_app/zasloni/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Responsive(
                mobile: DashboardScreenMobile(),
                desktop: DashboardScreenDesktop());
          } else {
            return Responsive(
                mobile: LoginScreenMobile(), desktop: LoginScreenDesktop());
          }
        },
      ),
    );
  }
}
