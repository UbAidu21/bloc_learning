import 'dart:convert';
import 'dart:io';
import 'package:bloc_learning/blocss/02_bloc_1/bloc_actions.dart';
import 'package:bloc_learning/blocss/02_bloc_1/person_model.dart';
import 'package:bloc_learning/blocss/02_bloc_1/person_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

HttpClient httpClient = HttpClient()
  ..badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

Future<Iterable<Person>> getPerson(String url) async {
  final response = await HttpClient().getUrl(Uri.parse(url));
  final jsonString = await response
      .close()
      .then((resp) => resp.transform(utf8.decoder).join());
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => Person.fromJson(e));
}

// {
//   return httpClient
//       .getUrl(Uri.parse(url))
//       .then((req) => req.close())
//       .then((resp) => resp.transform(utf8.decoder).join())
//       .then((str) => json.decode(str) as List<dynamic>)
//       .then((list) => list.map((e) => Person.fromJson(e)));
// }

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class S2BlocScren extends StatelessWidget {
  const S2BlocScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(
                          const LoadPersonAction(
                            url: personUrl1,
                            loader: getPerson,
                          ),
                        );
                  },
                  child: const Text('Load JSON 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(
                          const LoadPersonAction(
                            url: personUrl2,
                            loader: getPerson,
                          ),
                        );
                  },
                  child: const Text('Load JSON 2'),
                ),
              ],
            ),
            BlocBuilder<PersonBloc, FetchResult?>(
              buildWhen: (previousResult, currentResult) {
                return previousResult?.persons != currentResult?.persons;
              },
              builder: (context, fetchResult) {
                final persons = fetchResult?.persons;
                debugPrint(fetchResult.toString());
                if (persons == null) {
                  return const SizedBox();
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: persons.length,
                    itemBuilder: (context, index) {
                      final person = persons[index]!;
                      return ListTile(
                        title: Text(person.name),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
