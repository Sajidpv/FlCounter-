import 'package:counter/model/counter_model.dart';
import 'package:counter/model/user_settings_model.dart';
import 'package:counter/routes/route_names.dart';
import 'package:counter/view-model/bloc/counter_bloc.dart';
import 'package:counter/view/widgets/counter_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CounterDetailScreen extends StatelessWidget {
  final String counterId;

  const CounterDetailScreen({super.key, required this.counterId});

  @override
  Widget build(BuildContext context) {
    final userSettingsBox = Hive.box<UserSettings>('userSettingsBox');
    final settings = userSettingsBox.get('globalSettings');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter Detail"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, RoutesName.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        buildWhen: (previous, current) =>
            current is CounterSettingsUpdatedState,
        builder: (context, state) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: settings!.isFullScreenTap
                ? () {
                    context
                        .read<CounterBloc>()
                        .add(IncrementCounterEvent(counterId));
                  }
                : null,
            child: Stack(
              children: [
                if (settings.isFullScreenTap)
                  TapWidget(
                    counterId: counterId,
                    tapText: 'Tap anywhere',
                  )
                else
                  Positioned(
                    left: settings.tapAreaX,
                    top: settings.tapAreaY,
                    width: settings.tapWidth,
                    height: settings.tapHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.deepPurpleAccent,
                          width: 1,
                        ),
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => context
                            .read<CounterBloc>()
                            .add(IncrementCounterEvent(counterId)),
                        child: TapWidget(counterId: counterId),
                      ),
                    ),
                  )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: CounterActions(counterId: counterId),
      ),
    );
  }
}

class TapWidget extends StatelessWidget {
  const TapWidget({
    super.key,
    required this.counterId,
    this.tapText = 'Tap here',
  });

  final String counterId, tapText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box<CounterModel>('counters')
                .listenable(keys: [counterId]),
            builder: (context, Box<CounterModel> box, _) {
              final counter = box.get(counterId,
                  defaultValue:
                      CounterModel(id: counterId, name: 'Counter', count: 0));
              return Text(
                counter!.count.toString(),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              );
            },
          ),
          Text(tapText)
        ],
      ),
    );
  }
}
