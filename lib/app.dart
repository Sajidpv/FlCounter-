import 'package:counter/repository/counter_repository.dart';
import 'package:counter/repository/settings_repository.dart';
import 'package:counter/routes/route_names.dart';
import 'package:counter/routes/routes.dart';
import 'package:counter/view-model/bloc/counter_bloc.dart';
import 'package:counter/view/counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:counter/utils/quick_actions_handler.dart';

class MyApp extends StatefulWidget {
  final CounterRepository counterRepository;
  final SettingsRepository settingsRepository;

  const MyApp(this.counterRepository, this.settingsRepository, {super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _shortcutType;
  String? _counterId;
  String? _route;
  bool _navigationTriggered = false; // Prevent multiple navigation calls

  @override
  void initState() {
    super.initState();

    // Initialize Quick Actions with dynamic counters
    QuickActionsHandler(
      counterRepository: widget.counterRepository,
      onActionSelected: (String type, String? counterId, String route) {
        setState(() {
          _shortcutType = type;
          _counterId = counterId;
          _route = route;
        });
      },
    ).init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ensure navigation happens only once after dependencies are set
    if (!_navigationTriggered && _shortcutType != null) {
      _navigationTriggered = true;
      Future.microtask(() {
        if (_shortcutType == 'open_counter' && _counterId != null) {
          Navigator.pushNamed(context, _route ?? '', arguments: _counterId);
        } else if (_shortcutType == 'new_counter') {
          Navigator.pushNamed(context, _route ?? '');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CounterBloc(widget.counterRepository, widget.settingsRepository)
            ..add(LoadCountersEvent()),
      child: MaterialApp(
        title: 'FlCounter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        initialRoute: RoutesName.home,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
