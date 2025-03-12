import 'package:counter/model/user_settings_model.dart';
import 'package:counter/services/hive_services.dart';
import 'package:hive/hive.dart';

class SettingsRepository {
  final HiveService<UserSettings> hiveService;

  SettingsRepository(Box<UserSettings> userSettingsBox)
      : hiveService = HiveService(userSettingsBox);

  Future<void> updateTapSettings({
    required bool isFullScreenTap,
    required double tapAreaX,
    required double tapAreaY,
    required double tapWidth,
    required double tapHeight,
  }) async {
    final settings = hiveService.get('globalSettings') ?? UserSettings();
    settings
      ..isFullScreenTap = isFullScreenTap
      ..tapAreaX = tapAreaX
      ..tapAreaY = tapAreaY
      ..tapWidth = tapWidth
      ..tapHeight = tapHeight;
    await hiveService.update('globalSettings', settings);
  }

  UserSettings getSettings() {
    return hiveService.get('globalSettings') ?? UserSettings();
  }
}
