

enum NavLabelsMode {disabled, onlySelected, all}

NavLabelsMode? resolveNavLabelsMode(String? name) {
	switch (name) {
		case "disabled":
			return NavLabelsMode.disabled;
		case "onlySelected":
			return NavLabelsMode.onlySelected;
		case "all":
			return NavLabelsMode.all;
		default:
			return null;
	}
}
