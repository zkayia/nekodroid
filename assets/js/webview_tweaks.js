

"use strict";


const clickPlayButtonMaxAttemps = 20;


function clickPlayButton(currentAttempts, resolve, reject) {
  document.querySelector(".jw-icon.jw-icon-display.jw-button-color.jw-reset")?.click();
  setTimeout(() => {
    if ((document.getElementById("main-player").classList.contains("jw-state-idle"))) {
      if (currentAttempts >= clickPlayButtonMaxAttemps) {
        return reject();
      }
      return clickPlayButton(currentAttempts + 1, resolve, reject);
    };
    resolve();
  }, 250);
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

  document.querySelectorAll("body *:not(video, :has(video))").forEach(e => e.remove());

  //let i = 0;

  //while (i < maxAttemps && toRemove.length > 0) {
  //  toRemove.forEach(e => e.remove());
  //  toRemove = document.querySelectorAll("body *:not(video, :has(video))");
  //  i++;
  //}
}, false);
