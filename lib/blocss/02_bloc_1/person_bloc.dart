import 'package:bloc_learning/blocss/02_bloc_1/bloc_actions.dart';
import 'package:bloc_learning/blocss/02_bloc_1/person_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension IsEqualIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

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

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) &&
      isRetriveFromCache == other.isRetriveFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetriveFromCache);
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
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
          final loader = event.loader;
          final persons = await loader(url);
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
