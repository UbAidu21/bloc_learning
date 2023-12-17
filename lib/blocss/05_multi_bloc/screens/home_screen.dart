import 'package:bloc_learning/blocss/05_multi_bloc/blocs/bottom_bloc.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/blocs/top_bloc.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/model/constants.dart';
import 'package:bloc_learning/blocss/05_multi_bloc/screens/app_bloc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => TopBloc(
                waithBeforeLoading: const Duration(seconds: 10),
                urls: images,
              ),
            ),
            BlocProvider(
              create: (_) => BottomBloc(
                waithBeforeLoading: const Duration(seconds: 10),
                urls: images,
              ),
            ),
          ],
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBlocView<TopBloc>(),
              AppBlocView<BottomBloc>(),
            ],
          ),
        ),
      ),
    );
  }
}
