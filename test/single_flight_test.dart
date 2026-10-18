import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:sufenbao/util/single_flight.dart';

void main() {
  test('concurrent callers share the request, a later refresh runs again', () async {
    final flight = SingleFlight();
    final response = Completer<int>();
    var calls = 0;
    Future<int> load() { calls++; return response.future; }
    final first = flight.run('config', load);
    final second = flight.run('config', load);
    expect(identical(first, second), isTrue);
    expect(calls, 1);
    response.complete(42);
    expect(await first, 42);
    expect(await second, 42);
    expect(await flight.run('config', () async => ++calls), 2);
  });

  test('a failed request releases its key so the user can retry', () async {
    final flight = SingleFlight();
    await expectLater(flight.run<int>('config', () async => throw StateError('offline')),
        throwsStateError);
    expect(await flight.run('config', () async => 7), 7);
  });

  test('independent requests are not merged', () async {
    final flight = SingleFlight();
    expect(await Future.wait([
      flight.run('app', () async => 1),
      flight.run('commission', () async => 2),
    ]), [1, 2]);
  });

  test('synchronous failure also releases its key', () async {
    final flight = SingleFlight();
    await expectLater(flight.run<int>('config', () => throw StateError('offline')),
        throwsStateError);
    expect(await flight.run('config', () async => 3), 3);
  });
}
