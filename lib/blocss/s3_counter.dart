import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' show Random;

// Abstract Events: First Of All We have to Create an Abstract Event Class for our App.
abstract class CounterEvent {}

//Evvents: Here we will create our Events and Extends these events with Abstract Events.
class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class Add5 extends CounterEvent {}

class Subtract5 extends CounterEvent {}

class ChangeColorEvent extends CounterEvent {}

/// States: This is the State that we are going to change in our application.
///Currently we have two States means two different and unrelated States that we
///are going to change in our UI.
///1st One is the Counter Value when the user increment our decrement it.
///2nd is the Scaffold Color that we are going to change when the related event
///called.
class CounterState {
  final int count;
  final Color backgroundColor;

  ///We will declare it as final and required it in the constructor so we can use it
  ///further more.
  CounterState({required this.count, required this.backgroundColor});
}

/// BLoC:
/// THis is the main part of our Bloc State-managment. we create our Bloc class(CounterBloc)
/// that extents wit Bloc. If we notice that the Bloc asking for two things e.g, one is
///   1. Event(CounterEvent).
///   2. Current State(CounterState).
/// That we have already created above.
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  ///when we extends our class with Bloc it will ask for the initial State, So by using
  ///the Constructor we are going to declare the initial state of the app that First
  ///time our is run.
  ///After that if we see we have a function body to the Super constructor.
  CounterBloc()
      : super(CounterState(count: 0, backgroundColor: getRandomColor())) {
    /// In this Function we use have a function known as 'on<T>(event,emit){}'.
    /// '<T>': is the Type of Event that we want to use to change State.
    /// 'event': is the Functionality in our Event to change the state.
    /// 'emit': is the output of our on(){} method when the event is called or handle.
    /// if you check to the DataType of Event, it will give the Event name of the <T>.
    on<IncrementEvent>((event, emit) {
      emit(CounterState(
        count: state.count + 1,
        backgroundColor: getRandomColor(),
      ));
    });

    on<DecrementEvent>((event, emit) {
      if (state.count > 0) {
        emit(CounterState(
          count: state.count - 1,
          backgroundColor: getRandomColor(),
        ));
      }
    });

    on<Add5>((event, emit) {
      emit(CounterState(
        count: state.count + 5,
        backgroundColor: getRandomColor(),
      ));
    });

    on<Subtract5>((event, emit) {
      if (state.count >= 5) {
        emit(CounterState(
          count: state.count - 5,
          backgroundColor: getRandomColor(),
        ));
      }
    });

    on<ChangeColorEvent>((event, emit) {
      emit(CounterState(
        count: state.count,
        backgroundColor: getRandomColor(),
      ));
    });
  }
}

Color getRandomColor() {
  final Random random = Random();
  final int colorValue = random.nextInt(0xFFFFFF);
  return Color(colorValue | 0xFF000000);
}

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
                    color: state.backgroundColor),
              ),
            ),
            Text(
              context.select((CounterBloc bloc) =>
                  '${bloc.state.count} ${bloc.state.backgroundColor}'),
              style: TextStyle(
                  color: context.select(
                      (CounterBloc bloc) => bloc.state.backgroundColor)),
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
