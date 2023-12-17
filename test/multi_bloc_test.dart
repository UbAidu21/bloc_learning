// ignore: unused_import
import 'dart:typed_data' show Uint8List;
import 'package:bloc_learning/blocss/05_multi_bloc/actions/bloc_events.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/app_state/app_state.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/blocs/app_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state of the bloc should be Empty',
    build: () => AppBloc(
      urls: [],
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
  );
  blocTest<AppBloc, AppState>(
    'Load Valid Data and Compare the States',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data: text1Data, error: null),
    ],
  );
  blocTest<AppBloc, AppState>(
    'Test Throwing an error in url loader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      const AppState(isLoading: false, data: null, error: Errors.dummy),
    ],
  );
  blocTest<AppBloc, AppState>(
    'Test the ability to load more than one URL',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoadNextUrlEvent(),
      );
      appBloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data: text2Data, error: null),
      const AppState(isLoading: true, data: null, error: null),
      AppState(isLoading: false, data: text2Data, error: null),
    ],
  );
}
