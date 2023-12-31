import 'package:bloc_learning/blocss/05_multi_bloc/actions/bloc_events.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/app_state/app_state.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/blocs/app_bloc.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/extension/start_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({super.key});

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, appState) {
          if (appState.error != null) {
            return const Text('An Error occurred. Try again in a moment');
          } else if (appState.data != null) {
            return Image.memory(
              appState.data!,
              fit: BoxFit.cover,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
