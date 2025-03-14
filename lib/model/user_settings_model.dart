import 'package:hive/hive.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 1)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  bool isFullScreenTap;

  @HiveField(1)
  double tapAreaX;

  @HiveField(2)
  double tapAreaY;

  @HiveField(3)
  double tapWidth;

  @HiveField(4)
  double tapHeight;

  UserSettingsModel({
    this.isFullScreenTap = true,
    this.tapAreaX = 50,
    this.tapAreaY = 200,
    this.tapWidth = 100,
    this.tapHeight = 100,
  });
}
