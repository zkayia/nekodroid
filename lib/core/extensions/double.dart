extension DoubleX on double {
  String toPrettyString() {
    final whole = truncate();
    return whole == this ? whole.toString() : toString().replaceAll(".", ",");
  }
}
