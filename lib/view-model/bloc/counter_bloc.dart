import 'package:bloc/bloc.dart';
import 'package:counter/model/counter_model.dart';
import 'package:counter/model/user_settings_model.dart';

import 'package:counter/repository/counter_repository.dart';
import 'package:counter/repository/settings_repository.dart';
import 'package:counter/services/home_widget_services.dart';
import 'package:meta/meta.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final CounterRepository counterRepository;
  final SettingsRepository settingsRepository;

  CounterBloc(this.counterRepository, this.settingsRepository)
      : super(CounterInitial()) {
    on<LoadCountersEvent>(_onLoadCounters);
    on<AddCounterEvent>(_onAddCounter);
    on<IncrementCounterEvent>(_onIncrementCounter);
    on<JumpToCounterEvent>(_onJumpCounter);
    on<DecrementCounterEvent>(_onDecrementCounter);
    on<CounterSelectedEvent>(_onCounterSelected);
    on<UpdateTapSettingsEvent>(_onUpdateTapSettings);
    on<DeleteCounterEvent>(_onDeleteCounter);
  }

  void _onLoadCounters(LoadCountersEvent event, Emitter<CounterState> emit) {
    emit(CounterLoadingState());
    final counters = counterRepository.getAllCounters();
    final settings = settingsRepository.getSettings();

    emit(CounterSettingsUpdatedState(settings));
    emit(CounterLoadedState(counters));
  }

  void _onAddCounter(AddCounterEvent event, Emitter<CounterState> emit) async {
    emit(CounterLoadingState());
    await counterRepository.addCounter(event.name);
    emit(CounterLoadedState(counterRepository.getAllCounters()));
  }

  void _onIncrementCounter(
      IncrementCounterEvent event, Emitter<CounterState> emit) async {
    await counterRepository.incrementCounter(event.id, event.count);

    final counters = counterRepository.getAllCounters();
    emit(CounterLoadedState(counters));

    // Update home screen widget
    await WidgetService.updateWidget(event.id, event.count);
  }

  void _onDecrementCounter(
      DecrementCounterEvent event, Emitter<CounterState> emit) async {
    await counterRepository.decrementCounter(event.id, event.count);
    emit(CounterLoadedState(counterRepository.getAllCounters()));
    // Update home screen widget
    await WidgetService.updateWidget(event.id, event.count);
  }

  void _onJumpCounter(
      JumpToCounterEvent event, Emitter<CounterState> emit) async {
    await counterRepository.jumpToCount(event.counterId, event.targetCount);
    emit(CounterLoadedState(counterRepository.getAllCounters()));
    // Update home screen widget
    await WidgetService.updateWidget(event.counterId, event.targetCount);
  }

  void _onCounterSelected(
      CounterSelectedEvent event, Emitter<CounterState> emit) {
    emit(CounterLoadingState());
    final counter = counterRepository.getAllCounters().firstWhere(
        (c) => c.id == event.id,
        orElse: () => CounterModel(id: '', name: ''));

    if (counter.id.isNotEmpty) {
      emit(CounterOpenedState(counter));
    }
  }

  void _onUpdateTapSettings(
      UpdateTapSettingsEvent event, Emitter<CounterState> emit) async {
    await settingsRepository.updateTapSettings(
      isFullScreenTap: event.isFullScreenTap,
      tapAreaX: event.tapAreaX,
      tapAreaY: event.tapAreaY,
      tapWidth: event.tapWidth,
      tapHeight: event.tapHeight,
    );
    emit(CounterSettingsUpdatedState(settingsRepository.getSettings()));
  }

  void _onDeleteCounter(
      DeleteCounterEvent event, Emitter<CounterState> emit) async {
    await counterRepository.deleteCounter(event.id);
    emit(CounterLoadedState(counterRepository.getAllCounters()));
  }
}
