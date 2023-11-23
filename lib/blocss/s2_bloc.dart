import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction extends LoadAction {
  final PersonUrl url;

  const LoadPersonAction({required this.url}) : super();
}

enum PersonUrl {
  person1,
  person2,
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return 'https://webhook.site/793b6a74-f276-4243-a70f-9f71c51e35b1';
      case PersonUrl.person2:
        return 'https://webhook.site/2e7cd2f6-aae6-49f2-b2ad-d0ea35f4432e';
    }
  }
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['Name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person (Name: $name ,Age: $age )';
}

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

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetriveFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetriveFromCache,
  });

  @override
  String toString() =>
      'FetchResult(persons: $persons, isRetriveFromCache: $isRetriveFromCache)';
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonAction>(
      (event, emit) async {
        final url = event.url;

        if (_cache.containsKey(url)) {
          //We have the value in the cache
          final cachePersons = _cache[url]!;
          final result = FetchResult(
            persons: cachePersons,
            isRetriveFromCache: true,
          );

          emit(result);
        } else {
          final persons = await getPerson(url.urlString);
          _cache[url] = persons;
          final result = FetchResult(
            persons: persons,
            isRetriveFromCache: false,
          );
          emit(result);
        }
      },
    );
  }
}

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
                            url: PersonUrl.person1,
                          ),
                        );
                  },
                  child: const Text('Load JSON 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(
                          const LoadPersonAction(
                            url: PersonUrl.person2,
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
