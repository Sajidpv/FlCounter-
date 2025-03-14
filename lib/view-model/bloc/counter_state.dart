part of 'counter_bloc.dart';

@immutable
sealed class CounterState {}

class CounterInitial extends CounterState {}

class CounterLoadedState extends CounterState {
  final List<CounterModel> counters;
  CounterLoadedState(this.counters);
}

class CounterLoadingState extends CounterState {
  CounterLoadingState();
}

class CounterOpenedState extends CounterState {
  final CounterModel counters;
  CounterOpenedState(this.counters);
}

class CounterSettingsUpdatedState extends CounterState {
  final UserSettingsModel settings;
  CounterSettingsUpdatedState(this.settings);
}
