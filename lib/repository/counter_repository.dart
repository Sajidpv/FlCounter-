import 'package:counter/model/counter_model.dart';
import 'package:counter/services/hive_services.dart';
import 'package:hive/hive.dart';

class CounterRepository {
  final HiveService<CounterModel> hiveService;

  CounterRepository(Box<CounterModel> counterBox)
      : hiveService = HiveService(counterBox);

  Future<void> addCounter(String name) async {
    final newCounter = CounterModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    await hiveService.add(newCounter.id, newCounter);
  }

  List<CounterModel> getAllCounters() {
    return hiveService.getAll();
  }

  Future<void> incrementCounter(String id, int count) async {
    final counter = hiveService.get(id);
    if (counter != null) {
      counter.count += count;
      await hiveService.update(id, counter);
    }
  }

  Future<void> decrementCounter(String id, int count) async {
    final counter = hiveService.get(id);
    if (counter != null && counter.count > 0) {
      counter.count -= count;
      await hiveService.update(id, counter);
    }
  }

  Future<void> jumpToCount(String id, int targetCount) async {
    final counter = hiveService.get(id);
    if (counter != null) {
      counter.count =
          targetCount; // Set the counter directly to the target count
      await hiveService.update(id, counter);
    }
  }

  Future<void> deleteCounter(String id) async {
    await hiveService.delete(id);
  }
}
