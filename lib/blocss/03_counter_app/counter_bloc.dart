import 'package:bloc_learning/blocss/03_counter_app/counter_actions.dart';
import 'package:bloc_learning/blocss/03_counter_app/counter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' show Random;

Color getRandomColor() {
  final Random random = Random();
  final int colorValue = random.nextInt(0xFFFFFF);
  return Color(colorValue | 0xFF000000);
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
