import 'package:counter/view-model/bloc/counter_bloc.dart';
import 'package:counter/view/widgets/action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterActions extends StatelessWidget {
  const CounterActions({
    super.key,
    required this.counterId,
  });

  final String counterId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            showNumberInputDialog(
              context: context,
              title: "Decrement Counter",
              label: "Enter decrement value",
              onConfirm: (value) {
                context
                    .read<CounterBloc>()
                    .add(DecrementCounterEvent(counterId, value));
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showNumberInputDialog(
              context: context,
              title: "Increment Counter",
              label: "Enter increment value",
              onConfirm: (value) {
                context
                    .read<CounterBloc>()
                    .add(IncrementCounterEvent(counterId, count: value));
              },
            );
          },
        ),
        ElevatedButton(
          onPressed: () {
            showNumberInputDialog(
              context: context,
              title: "Jump to Counter Value",
              label: "Enter target count",
              onConfirm: (value) {
                context
                    .read<CounterBloc>()
                    .add(JumpToCounterEvent(counterId, value));
              },
            );
          },
          child: const Text("Jump to Count"),
        ),
        IconButton(
          icon: const Icon(Icons.restore),
          onPressed: () {
            showConfirmationDialog(
              context: context,
              title: "Reset Counter",
              message: "Are you sure you want to reset the counter to 0?",
              onConfirm: () {
                context
                    .read<CounterBloc>()
                    .add(JumpToCounterEvent(counterId, 0));
              },
            );
          },
        ),
      ],
    );
  }
}
