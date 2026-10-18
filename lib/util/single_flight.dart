/// 合并同时发起的同一任务，完成后移除，后续刷新仍会重新执行。
class SingleFlight {
  final Map<String, Future<dynamic>> _pending = {};

  Future<T> run<T>(String key, Future<T> Function() action) {
    final pending = _pending[key];
    if (pending != null) return pending as Future<T>;
    final future = Future<T>.sync(action).whenComplete(() {
      _pending.remove(key);
    });
    _pending[key] = future;
    return future;
  }
}
