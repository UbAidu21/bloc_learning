import 'package:flutter/material.dart';

/// Abstract Events: First Of All We have to Create an Abstract Event Class for our App.

@immutable
abstract class CounterEvent {}

///Evvents: Here we will create our Events and Extends these events with Abstract Events.
@immutable
class IncrementEvent extends CounterEvent {}

@immutable
class DecrementEvent extends CounterEvent {}

@immutable
class Add5 extends CounterEvent {}

@immutable
class Subtract5 extends CounterEvent {}

@immutable
class ChangeColorEvent extends CounterEvent {}
