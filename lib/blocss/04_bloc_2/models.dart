import 'package:flutter/foundation.dart' show immutable;

@immutable
class LoginHandle {
  final String token;

  const LoginHandle({
    required this.token,
  });
  const LoginHandle.fooBar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandle other) => token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginHandle (token = $token)';
}

enum LoginError { invalidHandle }

@immutable
class Notes {
  final String title;

  const Notes({required this.title});

  @override
  String toString() => 'Notes (tite = $title)';
}

final mockNotes = Iterable.generate(
  3,
  (i) => Notes(title: 'Note ${i + 1}'),
);
