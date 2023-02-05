import 'package:accounting_app/zasloni/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../gradniki/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        smallDesktop: RegisterScreenDesktop(),
        tablet: RegisterScreenDesktop(),
        mobile: RegisterScreenMobile(),
        desktop: RegisterScreenDesktop(),
      ),
    );
  }
}
