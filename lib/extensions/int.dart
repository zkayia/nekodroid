

extension ExtendedX on int {

  String toPaddedString([int length=2]) => toString().padLeft(length, "0");
}
