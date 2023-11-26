import 'package:bloc_learning/blocss/03_counter_app/counter_actions.dart';
import 'package:bloc_learning/blocss/03_counter_app/counter_bloc.dart';
import 'package:bloc_learning/blocss/03_counter_app/counter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// UI
class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Count:',
              style: TextStyle(fontSize: 20),
            ),

            ///So we can use two different approches for updating the UI.
            ///if we have a large set data then use BlocBuiled() to rebuild the widget
            ///but if we have a small size changes then we can use the the simple context.select()
            ///function which is more simple and editible.
            BlocBuilder<CounterBloc, CounterState>(
              buildWhen: (previous, current) =>
                  previous.count != current.count ||
                  previous.backgroundColor != previous.backgroundColor,
              builder: (context, state) => Text(
                '${state.count}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: state.backgroundColor,
                ),
              ),
            ),
            Text(
              context.select(
                (CounterBloc bloc) =>
                    '${bloc.state.count} ${bloc.state.backgroundColor}',
              ),
              style: TextStyle(
                color: context.select(
                  (CounterBloc bloc) => bloc.state.backgroundColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(IncrementEvent());
                  },
                  child: const Text('Increment'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(DecrementEvent());
                  },
                  child: const Text('Decrement'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Add5());
                  },
                  child: const Text('Add 5'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Subtract5());
                  },
                  child: const Text('Subtract 5'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CounterBloc>().add(ChangeColorEvent());
              },
              child: const Text('Change Color'),
            ),
          ],
        ),
      ),
    );
  }
}
