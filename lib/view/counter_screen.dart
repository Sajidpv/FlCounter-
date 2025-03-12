import 'package:counter/routes/route_names.dart';
import 'package:counter/view/widgets/action_dialog.dart';
import 'package:counter/view/widgets/drawer.dart';
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
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(counter.name),
                      subtitle: Text('Count: ${counter.count}'),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final counterNameController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Counter'),
                content: TextField(
                  controller: counterNameController,
                  decoration: const InputDecoration(hintText: 'Counter Name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (counterNameController.text.isNotEmpty) {
                        context
                            .read<CounterBloc>()
                            .add(AddCounterEvent(counterNameController.text));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
