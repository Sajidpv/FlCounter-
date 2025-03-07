import 'package:counter/model/counter_model.dart';
import 'package:counter/model/user_settings_model.dart';
import 'package:counter/view-model/bloc/counter_bloc.dart';
import 'package:counter/view/counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class MyApp extends StatelessWidget {
  final Box<CounterModel> counterBox;
  final Box<UserSettings> userSettingsBox;
  const MyApp(this.counterBox, this.userSettingsBox, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CounterBloc(counterBox, userSettingsBox)..add(LoadCountersEvent()),
      child: MaterialApp(
        title: 'FlCounter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const CounterScreen(),
      ),
    );
  }
}
