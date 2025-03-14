import 'package:counter/app.dart';
import 'package:counter/bloc_observers.dart';
import 'package:counter/configs/box_names.dart';
import 'package:counter/model/counter_model.dart';
import 'package:counter/model/user_settings_model.dart';
import 'package:counter/repository/counter_repository.dart';
import 'package:counter/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Hive.initFlutter();

  Hive.registerAdapter(CounterModelAdapter());
  Hive.registerAdapter(UserSettingsAdapter());

  final counterBox = await Hive.openBox<CounterModel>(COUNTER_BOX);
  final userSettingsBox = await Hive.openBox<UserSettingsModel>(USER_BOX);

  final counterRepository = CounterRepository(counterBox);
  final settingsRepository = SettingsRepository(userSettingsBox);

  // Set default tap settings if not already set
  if (userSettingsBox.get(USER_DETAILS) == null) {
    userSettingsBox.put(
      USER_DETAILS,
      UserSettingsModel(),
    );
  }
  runApp(MyApp(counterRepository, settingsRepository));
}
