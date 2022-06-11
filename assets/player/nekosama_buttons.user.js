// ==UserScript==
// @name         Neko Sama Buttons
// @description  Adds 8s quick forward and backward buttons, plus a intro skip button
// @version      1.2.4
// @author       zkayia
// @namespace    https://github.com/zkayia/usermods
// @downloadURL  https://github.com/zkayia/usermods/raw/master/src/scripts/nekosama_buttons.user.js
// @updateURL    https://github.com/zkayia/usermods/raw/master/src/scripts/nekosama_buttons.user.js
// @homepageURL  https://github.com/zkayia/usermods
// @supportURL   https://github.com/zkayia/usermods
// @match        https://www.pstream.net/e/*
// @run-at       document-body
// @grant        none
// ==/UserScript==

"use strict";


const customHTML = `
	<div id="cstm-button-container" style="display: flex; margin: 0 auto;">
		<style type="text/css">
			button.cstm-button {
				display: flex !important;
				justify-content: center !important;
				align-items: center !important;
				margin: 0 8px !important;
			}
			button.cstm-button svg {
				width: 50% !important;
				height: 50% !important;
			}
			button.cstm-button path {
				fill: rgba(232, 230, 227, 0.8) !important;
			}
			@media screen and (max-width:520px) {
				button.cstm-button {
					display: none !important;
				}
			}
		</style>
		<button id="cstm-button-bwd" class="cstm-button jw-icon jw-icon-inline jw-reset" >
			<svg viewBox="0 0 512 512">
				<path d="M255.545 8c-66.269.119-126.438 26.233-170.86 68.685L48.971 40.971C33.851 25.851 8 36.559 8 57.941V192c0 13.255 10.745 24 24 24h134.059c21.382 0 32.09-25.851 16.971-40.971l-41.75-41.75c30.864-28.899 70.801-44.907 113.23-45.273 92.398-.798 170.283 73.977 169.484 169.442C423.236 348.009 349.816 424 256 424c-41.127 0-79.997-14.678-110.63-41.556-4.743-4.161-11.906-3.908-16.368.553L89.34 422.659c-4.872 4.872-4.631 12.815.482 17.433C133.798 479.813 192.074 504 256 504c136.966 0 247.999-111.033 248-247.998C504.001 119.193 392.354 7.755 255.545 8z"></path>
			</svg>
		</button>
		<button id="cstm-button-skp" class="cstm-button jw-icon jw-icon-inline jw-reset">
			<svg viewBox="0 0 512 512">
				<path d="M500.5 231.4l-192-160C287.9 54.3 256 68.6 256 96v320c0 27.4 31.9 41.8 52.5 24.6l192-160c15.3-12.8 15.3-36.4 0-49.2zm-256 0l-192-160C31.9 54.3 0 68.6 0 96v320c0 27.4 31.9 41.8 52.5 24.6l192-160c15.3-12.8 15.3-36.4 0-49.2z"></path>
			</svg>
		</button>
		<button id="cstm-button-fwd" class="cstm-button jw-icon jw-icon-inline jw-reset">
			<svg viewBox="0 0 512 512">
				<path d="M256.455 8c66.269.119 126.437 26.233 170.859 68.685l35.715-35.715C478.149 25.851 504 36.559 504 57.941V192c0 13.255-10.745 24-24 24H345.941c-21.382 0-32.09-25.851-16.971-40.971l41.75-41.75c-30.864-28.899-70.801-44.907-113.23-45.273-92.398-.798-170.283 73.977-169.484 169.442C88.764 348.009 162.184 424 256 424c41.127 0 79.997-14.678 110.629-41.556 4.743-4.161 11.906-3.908 16.368.553l39.662 39.662c4.872 4.872 4.631 12.815-.482 17.433C378.202 479.813 319.926 504 256 504 119.034 504 8.001 392.967 8 256.002 7.999 119.193 119.646 7.755 256.455 8z"></path>
			</svg>
		</button>
	</div>
`;

function f_setTime(time) {
	const vid = document.querySelector("video");
	vid.currentTime = vid.currentTime + parseInt(time);
};

window.addEventListener("load", () => {
	const prev = document.querySelector(".jw-controls.jw-reset .jw-reset.jw-button-container .jw-reset.jw-spacer");
	prev.insertAdjacentHTML("afterend", customHTML);
	document.getElementById("cstm-button-bwd").addEventListener("click", () => {f_setTime(-8);}, false);
	document.getElementById("cstm-button-fwd").addEventListener("click", () => {f_setTime(8);}, false);
	document.getElementById("cstm-button-skp").addEventListener("click", () => {f_setTime(88);}, false);
	prev.remove();

	document.querySelector(".jw-icon-rewind.jw-icon-inline")?.remove();
	document.querySelector(".jw-icon-rewind")?.setAttribute("style", "visibility: hidden;");
}, false);
