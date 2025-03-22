extension StringX on String {
  String toTitleCase() {
    final buf = StringBuffer();
    buf.write(substring(0, 1).toUpperCase());
    buf.write(substring(1));
    return buf.toString();
  }
}
