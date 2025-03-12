import 'package:counter/model/user_settings_model.dart';
import 'package:counter/view-model/bloc/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tap Settings")),
      body: FutureBuilder<Box<UserSettings>>(
        future: Hive.openBox<UserSettings>('userSettingsBox'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userSettingsBox = snapshot.data!;
          UserSettings settings =
              userSettingsBox.get('globalSettings') ?? UserSettings();

          return BlocListener<CounterBloc, CounterState>(
            listenWhen: (previous, current) =>
                current is CounterSettingsUpdatedState,
            listener: (context, state) {
              if (state is CounterSettingsUpdatedState) {
                settings = state.settings;
              }
            },
            child: BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                if (state is CounterLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Enable Full-Screen Tap"),
                      value: settings.isFullScreenTap,
                      onChanged: (value) {
                        context.read<CounterBloc>().add(UpdateTapSettingsEvent(
                              isFullScreenTap: value,
                              tapAreaX: settings.tapAreaX,
                              tapAreaY: settings.tapAreaY,
                              tapWidth: settings.tapWidth,
                              tapHeight: settings.tapHeight,
                            ));
                      },
                    ),
                    if (!settings.isFullScreenTap)
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned(
                              left: settings.tapAreaX,
                              top: settings.tapAreaY,
                              width: settings.tapWidth,
                              height: settings.tapHeight,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  context.read<CounterBloc>().add(
                                        UpdateTapSettingsEvent(
                                          isFullScreenTap:
                                              settings.isFullScreenTap,
                                          tapAreaX: settings.tapAreaX +
                                              details.delta.dx,
                                          tapAreaY: settings.tapAreaY +
                                              details.delta.dy,
                                          tapWidth: settings.tapWidth,
                                          tapHeight: settings.tapHeight,
                                        ),
                                      );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: .5),
                                    border: Border.all(
                                        color: Colors.blue, width: 2),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onPanUpdate: (details) {
                                            context.read<CounterBloc>().add(
                                                  UpdateTapSettingsEvent(
                                                    isFullScreenTap: settings
                                                        .isFullScreenTap,
                                                    tapAreaX: settings.tapAreaX,
                                                    tapAreaY: settings.tapAreaY,
                                                    tapWidth: (settings
                                                                .tapWidth +
                                                            details.delta.dx)
                                                        .clamp(50, 300),
                                                    tapHeight: (settings
                                                                .tapHeight +
                                                            details.delta.dy)
                                                        .clamp(50, 300),
                                                  ),
                                                );
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
