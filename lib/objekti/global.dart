import 'package:flutter/cupertino.dart';

class Global {
  ValueNotifier<int> menuIndex = ValueNotifier(0);
  ValueNotifier<int> glavnaKnjigaIndex = ValueNotifier(0);
  ValueNotifier<int> stroskiIndex = ValueNotifier(0);
  ValueNotifier<int> prodajaIndex = ValueNotifier(0);
  ValueNotifier<int> projektiIndex = ValueNotifier(0);
  ValueNotifier<int> delavciIndex = ValueNotifier(0);

  late final String email;
  late final String id;
  late String card = '';
}

class EmailController {}
