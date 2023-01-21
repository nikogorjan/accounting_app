import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DashboardScreenDesktop extends StatefulWidget {
  const DashboardScreenDesktop({super.key});

  @override
  State<DashboardScreenDesktop> createState() => _DashboardScreenDesktopState();
}

class _DashboardScreenDesktopState extends State<DashboardScreenDesktop> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text('desktop'),
            Text('signed in as'),
            Text(user.email!),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text('izpis')),
          ],
        ),
      ),
    );
  }
}
