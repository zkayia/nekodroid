extension IterableX<E> on Iterable<E> {
  E? elementAtOrNull(int index) => length > index ? elementAt(index) : null;

  String? joinStrings([String separator = ""]) {
    final result = whereType<String>().join(separator);
    return result.isEmpty ? null : result;
  }
}
