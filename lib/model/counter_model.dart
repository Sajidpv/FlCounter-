import 'package:hive/hive.dart';

part 'counter_model.g.dart';

@HiveType(typeId: 0)
class CounterModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  int count;

  CounterModel({
    required this.id,
    required this.name,
    this.count = 0,
  });
}
