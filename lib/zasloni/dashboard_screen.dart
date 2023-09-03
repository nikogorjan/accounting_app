import 'package:accounting_app/gradniki/responsive.dart';
import 'package:accounting_app/zasloni/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../drawer/drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Responsive.isMobile(context) ? DrawerMenu() : null,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Responsive(
                smallDesktop: DashboardScreenSmallDesktop(),
                tablet: DashboardScreenTablet(),
                mobile: DashboardScreenMobile(),
                desktop: DashboardScreenDesktop());
          } else {
            return Responsive(
                smallDesktop: LoginScreenDesktop(),
                tablet: LoginScreenDesktop(),
                mobile: LoginScreenMobile(),
                desktop: LoginScreenDesktop());
          }
        },
      ),
    );
  }
}
