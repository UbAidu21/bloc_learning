import 'package:bloc_learning/blocss/04_bloc_2/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Notes>?> getNotes({
    required LoginHandle loginHandle,
  });
}

class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Notes>?> getNotes({required LoginHandle loginHandle}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null,
      );
}
