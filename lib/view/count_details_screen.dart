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
              ),
            ),
            icon: const Icon(Icons.settings),
          )
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
                if (settings.isFullScreenTap)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          counter.count.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              heroTag: "decrement",
                              onPressed: () {
                                context
                                    .read<CounterBloc>()
                                    .add(DecrementCounterEvent(counter.id, 10));
                              },
                              child: const Icon(Icons.remove),
                            ),
                            const SizedBox(width: 20),
                            FloatingActionButton(
                              heroTag: "increment",
                              onPressed: () {
                                context
                                    .read<CounterBloc>()
                                    .add(IncrementCounterEvent(counter.id));
                              },
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
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
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                counter.count.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      context.read<CounterBloc>().add(
                                          DecrementCounterEvent(
                                              counter.id, 10));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      context.read<CounterBloc>().add(
                                          IncrementCounterEvent(counter.id));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
