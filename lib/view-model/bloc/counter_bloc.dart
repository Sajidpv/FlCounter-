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
    on<LoadCountersEvent>((event, emit) {
      emit(CounterLoadingState());
      final counters = counterBox.values.toList();
      final settings = userSettingsBox.get('globalSettings') ?? UserSettings();

      emit(CounterSettingsUpdatedState(settings));
      emit(CounterLoadedState(counters));
    });

    on<AddCounterEvent>((event, emit) {
      emit(CounterLoadingState());
      final newCounter = CounterModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
      );
      counterBox.put(newCounter.id, newCounter);
      emit(CounterLoadedState(counterBox.values.toList()));
    });

    on<IncrementCounterEvent>((event, emit) {
      print('object');
      final counter = counterBox.get(event.id);
      if (counter != null) {
        counter.count++;
        counterBox.put(counter.id, counter);
        emit(CounterLoadedState(counterBox.values.toList()));
      }
    });

    on<CounterSelectedEvent>((event, emit) {
      emit(CounterLoadingState());
      final counter = counterBox.get(event.id);
      if (counter != null) {
        emit(CounterOpenedState(counter));
      }
    });

    on<UpdateTapSettingsEvent>((event, emit) {
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
    });

    on<DeleteCounterEvent>((event, emit) {
      counterBox.delete(event.id);
      emit(CounterLoadedState(counterBox.values.toList()));
    });
  }
}
