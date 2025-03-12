import 'package:counter/routes/route_names.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:counter/repository/counter_repository.dart';
import 'package:counter/model/counter_model.dart';

class QuickActionsHandler {
  final CounterRepository counterRepository;
  final Function(String, String?, String) onActionSelected;

  QuickActionsHandler(
      {required this.counterRepository, required this.onActionSelected});

  Future<void> init() async {
    final QuickActions quickActions = QuickActions();

    // Fetch all counters from Hive
    final List<CounterModel> counters =
        await counterRepository.getAllCounters();

    // Create dynamic quick action items
    List<ShortcutItem> quickActionItems = [
      ShortcutItem(
          type: 'new_counter',
          localizedTitle: 'Create Counter',
          icon: 'new_counter'),
    ];

    // Add each counter as a quick action
    for (var counter in counters) {
      quickActionItems.add(
        ShortcutItem(
          type: 'open_counter_${counter.id}',
          localizedTitle: 'Open ${counter.name}',
          icon: 'open_counter',
        ),
      );
    }

    quickActions.setShortcutItems(quickActionItems);

    // Handle shortcut selection
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'new_counter') {
        onActionSelected(shortcutType, null, RoutesName.home);
      } else if (shortcutType.startsWith('open_counter_')) {
        String counterId = shortcutType.replaceFirst('open_counter_', '');
        onActionSelected('open_counter', counterId, RoutesName.open_counter);
      }
    });
  }
}
