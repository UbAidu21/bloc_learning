import 'package:bloc_learning/blocss/04_bloc_2/actions/actions.dart';
import 'package:bloc_learning/blocss/04_bloc_2/api/login_api.dart';
import 'package:bloc_learning/blocss/04_bloc_2/api/notes_api.dart';
import 'package:bloc_learning/blocss/04_bloc_2/app_state/app_state.dart';
import 'package:bloc_learning/blocss/04_bloc_2/bloc/app_bloc.dart';
import 'package:bloc_learning/blocss/04_bloc_2/dialoge/generic_dialoge.dart';
import 'package:bloc_learning/blocss/04_bloc_2/dialoge/loading_screen.dart';
import 'package:bloc_learning/blocss/04_bloc_2/models.dart';
import 'package:bloc_learning/blocss/04_bloc_2/screens/iterbale_listview.dart';
import 'package:bloc_learning/blocss/04_bloc_2/screens/login_view.dart';
import 'package:bloc_learning/blocss/04_bloc_2/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi.instance(),
        notesApi: NotesApi(),
        acceptedLoginHandle: const LoginHandle.fooBar(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            //Loading Screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            //Errors
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            //if we login but have no fetched notes, fetch them now,
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesActions());
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginScreen(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
