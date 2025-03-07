import 'package:counter/app.dart';
import 'package:counter/bloc_observers.dart';
import 'package:counter/model/counter_model.dart';
import 'package:counter/model/user_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter(CounterModelAdapter());
  Hive.registerAdapter(UserSettingsAdapter());
  final counterBox = await Hive.openBox<CounterModel>('counters');
  final userSettingsBox = await Hive.openBox<UserSettings>('userSettingsBox');
  // Set default tap settings if not already set
  if (userSettingsBox.get('globalSettings') == null) {
    userSettingsBox.put(
      'globalSettings',
      UserSettings(
        isFullScreenTap: true,
        tapAreaX: 100,
        tapAreaY: 100,
        tapWidth: 200,
        tapHeight: 200,
      ),
    );
  }
  runApp(MyApp(counterBox, userSettingsBox));
}
