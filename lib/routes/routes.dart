import 'package:counter/view/count_details_screen.dart';
import 'package:counter/view/counter_screen.dart';
import 'package:counter/view/settings_screen.dart';
import 'package:flutter/material.dart';

import 'route_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CounterScreen());

      case RoutesName.open_counter:
        final String id = settings.arguments as String;
        return MaterialPageRoute(
            builder: (BuildContext context) => CounterDetailScreen(
                  counterId: id,
                ));

      case RoutesName.settings:
        return MaterialPageRoute(
            builder: (BuildContext context) => SettingsScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text(RoutesName.no_route),
            ),
          );
        });
    }
  }
}
