import 'package:bloc_learning/blocss/02_bloc_1/bloc_actions.dart';
import 'package:bloc_learning/blocss/02_bloc_1/person_bloc.dart';
import 'package:bloc_learning/blocss/02_bloc_1/person_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(
    name: 'Foo 1',
    age: 20,
  ),
  Person(
    name: 'Bar 1',
    age: 30,
  ),
];
const mockedPersons2 = [
  Person(
    name: 'Foo 2',
    age: 20,
  ),
  Person(
    name: 'Bar 2',
    age: 30,
  ),
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);
Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group(
    'Testing our Bloc',
    () {
      ///Our Tests goes here
      late PersonBloc bloc;
      setUp(() {
        bloc = PersonBloc();
      });

      blocTest<PersonBloc, FetchResult?>(
        'Test Initial State',
        build: () => bloc,
        verify: (bloc) => expect(bloc.state, null),
      );

      ///Fetch Mock Data and Compare with the FetchResult
      blocTest<PersonBloc, FetchResult?>(
        'Mock Retriveing Personf rom First Iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonAction(
              url: 'dummy_url_1',
              loader: mockGetPersons1,
            ),
          );
          bloc.add(
            const LoadPersonAction(
              url: 'dummy_url_1',
              loader: mockGetPersons1,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons1,
            isRetriveFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons1,
            isRetriveFromCache: true,
          ),
        ],
      );

      blocTest<PersonBloc, FetchResult?>(
        'Mock Retriveing Person2 rom Second Iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
          bloc.add(
            const LoadPersonAction(
              url: 'dummy_url_2',
              loader: mockGetPersons2,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons2,
            isRetriveFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons2,
            isRetriveFromCache: true,
          ),
        ],
      );
    },
  );
}
