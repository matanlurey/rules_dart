import 'package:args/args.dart';

void main(List<String> args) {
  // Demos the use of the `args` package.
  final parser = ArgParser()
    ..addFlag('verbose', abbr: 'v', negatable: false)
    ..addOption('mode', abbr: 'm', allowed: ['debug', 'release']);

  final results = parser.parse(args);
  print('verbose: ${results['verbose']}');
  print('mode: ${results['mode']}');
}
