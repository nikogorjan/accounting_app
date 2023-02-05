import 'package:hive/hive.dart';

part 'hive_global.g.dart';

@HiveType(typeId: 1)
class HiveGlobal {
  HiveGlobal({required this.email});
  @HiveField(0)
  String email;
}
