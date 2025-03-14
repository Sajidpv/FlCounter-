import 'package:counter/routes/route_names.dart';
import 'package:counter/view/widgets/action_dialog.dart';
import 'package:counter/view/widgets/drawer.dart';
import 'package:counter/view/widgets/fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view-model/bloc/counter_bloc.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Counter')),
      drawer: SideDrawer(),
      body: BlocConsumer<CounterBloc, CounterState>(
        listener: (context, state) {
          if (state is CounterOpenedState) {
            Navigator.pushNamed(context, RoutesName.open_counter,
                    arguments: state.counters.id)
                .then((_) {
              context.read<CounterBloc>().add(LoadCountersEvent());
            });
          }
        },
        builder: (context, state) {
          if (state is CounterLoadedState) {
            return ListView.builder(
              itemCount: state.counters.length,
              itemBuilder: (context, index) {
                final counter = state.counters[index];
                return GestureDetector(
                  onTap: () => context
                      .read<CounterBloc>()
                      .add(CounterSelectedEvent(counter.id)),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(counter.name),
                      subtitle: Text('Count: ${counter.count}'),
                      trailing: IconButton(
                          icon: Icon(Icons.delete_sharp,
                              color: Colors.red.shade300),
                          onPressed: () => showConfirmationDialog(
                                context: context,
                                title: "Delete Counter",
                                message:
                                    "Are you sure you want to delete counter ${counter.name}?",
                                onConfirm: () => context
                                    .read<CounterBloc>()
                                    .add(DeleteCounterEvent(counter.id)),
                              )),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FAB(),
    );
  }
}
