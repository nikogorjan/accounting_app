import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Responsive extends StatelessWidget {
  const Responsive(
      {super.key,
      required this.mobile,
      required this.desktop,
      required this.tablet,
      required this.smallDesktop});

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final Widget smallDesktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isSmallDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200 &&
      MediaQuery.of(context).size.width < 1600;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1600) {
          return desktop;
        } else if (constraints.maxWidth < 1600 &&
            constraints.maxWidth >= 1200) {
          return smallDesktop;
        } else if (constraints.maxWidth < 1200 && constraints.maxWidth >= 800) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
