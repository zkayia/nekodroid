

"use strict";


// Remove ads and bloat html elements
[
	".adsBox",
	".afs_ads",
	".ad-placement",
	"a",
	"iframe",
	"body > div:not(.video-js)",
	"body > script",
].forEach(
	sel => document.querySelectorAll(sel).forEach(
		el => el?.remove()
	)
);
