import 'package:bloc_learning/blocss/04_bloc_2/actions/actions.dart';
import 'package:bloc_learning/blocss/04_bloc_2/api/login_api.dart';
import 'package:bloc_learning/blocss/04_bloc_2/api/notes_api.dart';
import 'package:bloc_learning/blocss/04_bloc_2/app_state/app_state.dart';
import 'package:bloc_learning/blocss/04_bloc_2/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;
  final LoginHandle acceptedLoginHandle;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
    required this.acceptedLoginHandle,
  }) : super(const AppState.empty()) {
    on<LoginAction>(
      (event, emit) async {
        //Start Loading
        emit(
          const AppState(
            isLoading: true,
            loginError: null,
            loginHandle: null,
            fetchedNotes: null,
          ),
        );
        //Log the User In
        final loginHandle = await loginApi.login(
          email: event.email,
          password: event.password,
        );

        emit(
          AppState(
            isLoading: false,
            loginError: loginHandle == null ? LoginError.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      },
    );

    on<LoadNotesActions>(
      (event, emit) async {
        //Start Loading
        emit(
          AppState(
            isLoading: true,
            loginError: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );
        //Get Login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != acceptedLoginHandle) {
          //invalid Login handle, cannot fetch the notes
          emit(
            AppState(
              isLoading: false,
              loginError: LoginError.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }
        //We have valid handle login, fetching notes
        final notes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      },
    );
  }
}
