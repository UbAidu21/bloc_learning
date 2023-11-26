import 'package:bloc_learning/blocss/04_bloc_2/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final LoginError? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Notes>? fetchedNotes;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginError': loginError,
        'loginHandle': loginHandle,
        'fetchedNotes': fetchedNotes,
      }.toString();
}
