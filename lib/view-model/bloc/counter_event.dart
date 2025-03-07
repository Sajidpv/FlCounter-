part of 'counter_bloc.dart';

@immutable
sealed class CounterEvent {}

class LoadCountersEvent extends CounterEvent {}

class AddCounterEvent extends CounterEvent {
  final String name;
  AddCounterEvent(this.name);
}

class IncrementCounterEvent extends CounterEvent {
  final String id;
  IncrementCounterEvent(this.id);
}

class CounterSelectedEvent extends CounterEvent {
  final String id;
  CounterSelectedEvent(this.id);
}

class UpdateTapSettingsEvent extends CounterEvent {
  final bool isFullScreenTap;
  final double tapAreaX;
  final double tapAreaY;
  final double tapWidth;
  final double tapHeight;

  UpdateTapSettingsEvent({
    required this.isFullScreenTap,
    required this.tapAreaX,
    required this.tapAreaY,
    required this.tapWidth,
    required this.tapHeight,
  });
}

class DeleteCounterEvent extends CounterEvent {
  final String id;
  DeleteCounterEvent(this.id);
}
