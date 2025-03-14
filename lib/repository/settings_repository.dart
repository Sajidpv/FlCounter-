import 'package:counter/configs/box_names.dart';
import 'package:counter/model/user_settings_model.dart';
import 'package:counter/services/hive_services.dart';
import 'package:hive/hive.dart';

class SettingsRepository {
  final HiveService<UserSettingsModel> hiveService;

  SettingsRepository(Box<UserSettingsModel> userSettingsBox)
      : hiveService = HiveService(userSettingsBox);

  Future<void> updateTapSettings({
    required bool isFullScreenTap,
    required double tapAreaX,
    required double tapAreaY,
    required double tapWidth,
    required double tapHeight,
  }) async {
    final settings = hiveService.get(USER_DETAILS) ?? UserSettingsModel();
    settings
      ..isFullScreenTap = isFullScreenTap
      ..tapAreaX = tapAreaX
      ..tapAreaY = tapAreaY
      ..tapWidth = tapWidth
      ..tapHeight = tapHeight;
    await hiveService.update(USER_DETAILS, settings);
  }

  UserSettingsModel getSettings() {
    return hiveService.get(USER_DETAILS) ?? UserSettingsModel();
  }
}
