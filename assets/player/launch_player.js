// ==UserScript==
// @name         test2
// @description  6/17/2022, 9:59:53 PM
// @version      1.0.0
// @author       zkayia
// @match        https://www.pstream.net/e/QJ9d0PxpD1oywqV
// @run-at       document-body
// @grant        none
// ==/UserScript==


"use strict";


const maxAttemps = 10;

function clickPlayButton(currentAttempts, resolve, reject) {
	document.querySelector(".jw-icon.jw-icon-display.jw-button-color.jw-reset")?.click();
	setTimeout(
		() => {
			if ((document.getElementById("main-player").classList.contains("jw-state-idle"))) {
				if (currentAttempts >= maxAttemps) {
					return reject();
				}
				return clickPlayButton(currentAttempts + 1);
			};
			resolve()
		},
		500,
	);
}


window.addEventListener("load", async () => {
	
	await new Promise((resolve, reject) => clickPlayButton(0, resolve, reject));
	
	[...document.querySelectorAll("#jw-settings-submenu-quality button")].filter(
		e => !e.getAttribute("aria-label").toLowerCase().includes("auto"),
	).forEach(e => e.click());
	
}, false);