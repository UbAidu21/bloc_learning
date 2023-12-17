import 'package:bloc_learning/blocss/05_multi_bloc/actions/bloc_events.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/app_state/app_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);
typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  Future<Uint8List> _loadUrl(String url) => NetworkAssetBundle(Uri.parse(url))
      .load(url)
      .then((bytesData) => bytesData.buffer.asUint8List());

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforLoading,
    AppBlocRandomUrlPicker? urlPicker,
    AppBlocUrlLoader? urlLoader,
  }) : super(const AppState.empty()) {
    on<LoadNextUrlEvent>((event, emit) async {
      emit(const AppState(isLoading: true, data: null, error: null));
      final url = (urlPicker ?? _pickRandomUrl)(urls);
      try {
        if (waitBeforLoading != null) {
          await Future.delayed(waitBeforLoading);
        }
        final data = await (urlLoader ?? _loadUrl)(url);
        emit(AppState(isLoading: false, data: data, error: null));
      } catch (e) {
        emit(AppState(isLoading: false, data: null, error: e));
      }
    });
  }
}
