

extension DateTimeX on DateTime? {

	Duration nowDiffOrZero() => this?.difference(DateTime.now()).abs() ?? Duration.zero;
}
