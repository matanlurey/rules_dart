import 'package:meta/meta.dart';

String message(String location) => 'Hello, $location!';

final class Foo {
  @nonVirtual
  String get world => 'world';
}
