import 'package:bloc_learning/blocss/02_bloc_1/person_bloc.dart';
import 'package:bloc_learning/blocss/02_bloc_1/s2_bloc_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 20)),
      ),
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: const S2BlocScren(),
      ),
    );
  }
}
