import 'package:bloc_learning/blocss/02_bloc_1/person_model.dart';
import 'package:flutter/foundation.dart' show immutable;

// enum PersonUrl {
//   person1,
//   person2,
// }

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.person1:
//         return 'https://webhook.site/793b6a74-f276-4243-a70f-9f71c51e35b1';
//       case PersonUrl.person2:
//         return 'https://webhook.site/2e7cd2f6-aae6-49f2-b2ad-d0ea35f4432e';
//     }
//   }
// }

const String personUrl1 =
    'https://webhook.site/793b6a74-f276-4243-a70f-9f71c51e35b1';
const String personUrl2 =
    'https://webhook.site/2e7cd2f6-aae6-49f2-b2ad-d0ea35f4432e';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction extends LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadPersonAction({
    required this.url,
    required this.loader,
  }) : super();
}
