import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetService {
  static const platform = MethodChannel('com.sajid.counter/widget');

  static Future<void> updateWidget(String counterId, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter_$counterId', count);
    try {
      await platform.invokeMethod('updateWidget');
    } on PlatformException catch (e) {
      print("Failed to update widget: ${e.message}");
    }
  }
}
