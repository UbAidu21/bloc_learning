import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_learning/blocss/04_bloc_2/actions/actions.dart';
import 'package:bloc_learning/blocss/04_bloc_2/bloc/app_bloc.dart';
import 'package:bloc_learning/blocss/04_bloc_2/api/login_api.dart';
import 'package:bloc_learning/blocss/04_bloc_2/api/notes_api.dart';
import 'package:bloc_learning/blocss/04_bloc_2/app_state/app_state.dart';
import 'package:bloc_learning/blocss/04_bloc_2/models.dart';

const Iterable<Notes> mockNotes = [
  Notes(title: 'Note 1'),
  Notes(title: 'Note 2'),
  Notes(title: 'Note 3'),
];

const acceptedLoginHandle = LoginHandle(token: 'ABC');

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptLoginHandle;
  final Iterable<Notes>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Notes>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn,
  });
  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

void main() {
  blocTest<AppBloc, AppState>(
    'Initial State of the bloc should be AppState.empty()',
    build: () => AppBloc(
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    verify: (appState) => expect(
      appState.state,
      const AppState.empty(),
    ),
  );
  blocTest<AppBloc, AppState>(
    'Can we log in with correct credentials',
    build: () => AppBloc(
      acceptedLoginHandle: acceptedLoginHandle,
      loginApi: const DummyLoginApi(
        acceptedEmail: 'bar@baz.com',
        acceptedPassword: 'foo',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'We should not be able to log in with invalid credentials.',
    build: () => AppBloc(
      acceptedLoginHandle: acceptedLoginHandle,
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@baz.com',
        acceptedPassword: 'baz',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'bar@baz.com',
        password: 'foo',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: LoginError.invalidHandle,
        loginHandle: null,
        fetchedNotes: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'Load Some Notes with a Valid Login Handle',
    build: () => AppBloc(
      acceptedLoginHandle: acceptedLoginHandle,
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@bar.com',
        acceptedPassword: 'baz',
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi(
        acceptLoginHandle: acceptedLoginHandle,
        notesToReturnForAcceptedLoginHandle: mockNotes,
      ),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoginAction(
          email: 'foo@bar.com',
          password: 'baz',
        ),
      );
      appBloc.add(const LoadNotesActions());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: mockNotes,
      ),
    ],
  );
}
