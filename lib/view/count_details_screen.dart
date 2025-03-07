import 'package:counter/model/counter_model.dart';
import 'package:counter/model/user_settings_model.dart';
import 'package:counter/view-model/bloc/counter_bloc.dart';
import 'package:counter/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class CounterDetailScreen extends StatelessWidget {
  final CounterModel counter;

  const CounterDetailScreen({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    final userSettingsBox = Hive.box<UserSettings>('userSettingsBox');
    final settings = userSettingsBox.get('globalSettings');

    return Scaffold(
      appBar: AppBar(
        title: Text(counter.name),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  )),
              icon: Icon(Icons.settings))
        ],
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: settings!.isFullScreenTap
                ? () {
                    context
                        .read<CounterBloc>()
                        .add(IncrementCounterEvent(counter.id));
                  }
                : null,
            child: Stack(
              children: [
                if (!settings.isFullScreenTap)
                  Positioned(
                    left: settings.tapAreaX,
                    top: settings.tapAreaY,
                    width: settings.tapWidth,
                    height: settings.tapHeight,
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<CounterBloc>()
                            .add(IncrementCounterEvent(counter.id));
                      },
                      child: Container(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ),
                Center(
                  child: Text(
                    'Counter Value: ${counter.count}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
