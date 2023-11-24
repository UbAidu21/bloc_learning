import 'package:flutter/material.dart' show immutable;

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
