

extension IterableX<E> on Iterable<E> {

  E? firstWhereOrNull(bool Function(E element) test, {E? Function()? orElse}) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return orElse?.call();
  }

  E? elementAtOrNull(int index) => length > index ? elementAt(index) : null;
}
