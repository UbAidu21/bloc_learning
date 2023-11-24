import 'package:flutter/material.dart';

/// States: This is the State that we are going to change in our application.
///Currently we have two States means two different and unrelated States that we
///are going to change in our UI.
///1st One is the Counter Value when the user increment our decrement it.
///2nd is the Scaffold Color that we are going to change when the related event
///called.
@immutable
class CounterState {
  final int count;
  final Color backgroundColor;

  ///We will declare it as final and required it in the constructor so we can use it
  ///further more.
  const CounterState({required this.count, required this.backgroundColor});
}
