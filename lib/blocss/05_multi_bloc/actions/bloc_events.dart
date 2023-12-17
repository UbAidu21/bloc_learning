import 'package:flutter/material.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class LoadNextUrlEvent implements AppEvent {
  const LoadNextUrlEvent();
}
