

extension ExtendedInt on int {

	String toPaddedString() => "${this < 10 ? "0" : ""}$this";
}
