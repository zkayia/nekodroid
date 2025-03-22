extension ListX<T> on List<T> {
  List<T> withSeparator(T separator) => [
        for (int i = 0; i < length; i++) ...[
          elementAt(i),
          if (i < length - 1) separator,
        ],
      ];
}
