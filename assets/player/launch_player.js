// ==UserScript==
// @name         launch_player
// @description  Launches the player by trying to press play.
// @version      1.0.0
// @author       zkayia
// @match        https://www.pstream.net/e/*
// @run-at       document-body
// @grant        none
// ==/UserScript==


"use strict";


const maxAttemps = 10;

function clickPlayButton(currentAttempts, resolve, reject) {
	document.querySelector(".jw-icon.jw-icon-display.jw-button-color.jw-reset")?.click();
	setTimeout(() => {
		if ((document.getElementById("main-player").classList.contains("jw-state-idle"))) {
			if (currentAttempts >= maxAttemps) {
				return reject();
			}
			return clickPlayButton(currentAttempts + 1, resolve, reject);
		};
		resolve();
	}, 500);
};

window.addEventListener("load", async () => {
	
	await new Promise((resolve, reject) => clickPlayButton(0, resolve, reject));

	[
		...document.querySelectorAll("#jw-settings-submenu-quality button"),
	].filter(
		e => !e.getAttribute("aria-label").toLowerCase().includes("auto"),
	).forEach(
		e => e.click(),
	);

	
	// jwplayer().on("levels", (_) => {
		
	// 	const getCurrent = () => {
	// 		try {
	// 			return qualities[jwplayer().getVisualQuality().index - 1];
	// 		} catch (e) {
	// 			return null;
	// 		};
	// 	};

	// 	const qualities = jwplayer().getQualityLevels().filter((e) => e.bitrate != null);
	// 	const current = getCurrent();

	// 	console.log(`nekodroid_data:${
	// 		JSON.stringify({
	// 			"qualities": qualities,
	// 			"current": current,
	// 		})
	// 	}`);
	// });
}, false);
