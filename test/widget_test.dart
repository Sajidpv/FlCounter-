// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:counter/app.dart';
import 'package:counter/configs/box_names.dart';
import 'package:counter/model/counter_model.dart';
import 'package:counter/model/user_settings_model.dart';
import 'package:counter/repository/counter_repository.dart';
import 'package:counter/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await Hive.initFlutter();
    Hive.registerAdapter(CounterModelAdapter());

    // Open the box for counters
    final counterBox = await Hive.openBox<CounterModel>(COUNTER_BOX);
    final userSettingsBox = await Hive.openBox<UserSettingsModel>(USER_BOX);
    final counterRepository = CounterRepository(counterBox);
    final settingsRepository = SettingsRepository(userSettingsBox);
    await tester.pumpWidget(MyApp(counterRepository, settingsRepository));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
