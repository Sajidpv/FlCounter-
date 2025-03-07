import 'package:bloc/bloc.dart';
import 'package:counter/model/counter_model.dart';
import 'package:counter/model/user_settings_model.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final Box<CounterModel> counterBox;
  final Box<UserSettings> userSettingsBox;

  CounterBloc(this.counterBox, this.userSettingsBox) : super(CounterInitial()) {
    on<LoadCountersEvent>(_onLoadCounters);
    on<AddCounterEvent>(_onAddCounter);
    on<IncrementCounterEvent>(_onIncrementCounter);
    on<DecrementCounterEvent>(_onDecrementCounter);
    on<CounterSelectedEvent>(_onCounterSelected);
    on<UpdateTapSettingsEvent>(_onUpdateTapSettings);
    on<DeleteCounterEvent>(_onDeleteCounter);
  }

  void _onLoadCounters(LoadCountersEvent event, Emitter<CounterState> emit) {
    emit(CounterLoadingState());
    final counters = counterBox.values.toList();
    final settings = userSettingsBox.get('globalSettings') ?? UserSettings();

    emit(CounterSettingsUpdatedState(settings));
    emit(CounterLoadedState(counters));
  }

  void _onAddCounter(AddCounterEvent event, Emitter<CounterState> emit) {
    emit(CounterLoadingState());
    final newCounter = CounterModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: event.name,
    );
    counterBox.put(newCounter.id, newCounter);
    emit(CounterLoadedState(counterBox.values.toList()));
  }

  void _onIncrementCounter(
      IncrementCounterEvent event, Emitter<CounterState> emit) {
    final counter = counterBox.get(event.id);
    if (counter != null) {
      counter.count = counter.count + event.count;

      counterBox.put(counter.id, counter);
      emit(CounterLoadedState(counterBox.values.toList()));
    }
  }

  void _onDecrementCounter(
      DecrementCounterEvent event, Emitter<CounterState> emit) {
    final counter = counterBox.get(event.id);
    if (counter != null && counter.count > 0) {
      counter.count = counter.count - event.count;
      counterBox.put(counter.id, counter);
      emit(CounterLoadedState(counterBox.values.toList()));
    }
  }

  void _onCounterSelected(
      CounterSelectedEvent event, Emitter<CounterState> emit) {
    emit(CounterLoadingState());
    final counter = counterBox.get(event.id);
    if (counter != null) {
      emit(CounterOpenedState(counter));
    }
  }

  void _onUpdateTapSettings(
      UpdateTapSettingsEvent event, Emitter<CounterState> emit) {
    final settings = userSettingsBox.get('globalSettings');
    if (settings != null) {
      settings
        ..isFullScreenTap = event.isFullScreenTap
        ..tapAreaX = event.tapAreaX
        ..tapAreaY = event.tapAreaY
        ..tapWidth = event.tapWidth
        ..tapHeight = event.tapHeight;
      settings.save();
    }
  }

  void _onDeleteCounter(DeleteCounterEvent event, Emitter<CounterState> emit) {
    counterBox.delete(event.id);
    emit(CounterLoadedState(counterBox.values.toList()));
  }
}
