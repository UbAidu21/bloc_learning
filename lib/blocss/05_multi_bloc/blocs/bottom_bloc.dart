import 'package:bloc_learning/blocss/05_multi_bloc/blocs/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({
    Duration? waithBeforeLoading,
    required Iterable<String> urls,
  }) : super(
          waitBeforLoading: waithBeforeLoading,
          urls: urls,
        );
}
