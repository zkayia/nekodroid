extension IntX on int {
  String toPaddedString([int length = 2]) => toString().padLeft(length, "0");

  /// [min] & [max] inclusive, [min] <= [max]
  int loop(int min, int max) {
    assert(min <= max, "min must be inferior or equal to max");
    final a = max - min + 1;
    final b = (this - min) % a;
    return min + b + (b < 0 ? a : 0);
  }
}
