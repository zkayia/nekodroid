

"use strict";


const getVideoMaxAttemps = 100;
let videoUpdatesIsRunning = false;
let videoIsBuffering = false


function vidToMsInt(value) {
  return Math.trunc(value * 1000);
}

function clampNumber(value, start, end) {
  return Math.max(start, Math.min(value, end));
}

function timeRangesToMap(timeRanges) {
  const res = [];
  for (let i = 0; i < timeRanges.length; i++) {
    res.push({
      "start": vidToMsInt(timeRanges.start(i)),
      "end": vidToMsInt(timeRanges.end(i)),
    });
  }
  return res;
}

function tryGetVideoElement(currentAttempts, resolve, reject) {
  const video = document.querySelector("video");
  if (video == null) {
    if (currentAttempts >= getVideoMaxAttemps) {
      return reject();
    }
    return setTimeout(() => tryGetVideoElement(currentAttempts + 1, resolve, reject), 50);
  }
  resolve(video);
};

function getVideoElement() {
	return new Promise((resolve, reject) => tryGetVideoElement(0, resolve, reject));
}

function sendData(port, video) {
  const isReady = video.readyState !== 0;
  if (isReady) {
    port.postMessage(
      JSON.stringify({
        "error": video.error?.message,
        "paused": video.paused,
        "ended": video.ended,
        "muted": video.muted,
        "buffering": videoIsBuffering,
        "playbackRate": video.playbackRate,
        "volume": video.volume,
        "currentTime": vidToMsInt(video.currentTime),
        "duration": vidToMsInt(video.duration),
        "videoSize": {
          "width": video.videoWidth,
          "height": video.videoHeight,
        },
        "qualities": jwplayer()?.getQualityLevels()?.map((e, i) => ({"index": i, ...e})) ?? [],
        "currentQuality": jwplayer()?.getCurrentQuality(),
        "buffered": timeRangesToMap(video.buffered),
        "played": timeRangesToMap(video.played),
        "readyState": video.readyState,
        "networkState": video.networkState,
      }),
    );
  }
  setTimeout(() => sendData(port, video), isReady ? 400 : 100);
}

async function main(port) {
  if (videoUpdatesIsRunning || port == null) {
    return;
  }
  videoUpdatesIsRunning = true;
  
  const video = await getVideoElement();
  if (video == null) {
    videoUpdatesIsRunning = false;
    return;
  }
  
  port.onmessage = event => {
    let data = JSON.parse(event.data);
    const arg = data["arg"];
    
    switch (data["action"]) {
      
      case "set_playing":
        if (arg === true || (arg == null && (video.paused || video.ended))) {
          video.play();
        } else {
          video.pause();
        }
        break;
      
      case "set_mute":
        video.muted = arg ?? !video.muted;
        break;
      
      case "go_to":
        video.currentTime = Math.max(0, arg);
        break;
      
      case "move_by":
        video.currentTime += clampNumber(
          arg,
          -video.currentTime,
          video.duration - video.currentTime,
        );
        break;
      
      case "set_playback_speed":
        video.playbackRate = Math.max(0, arg);
        break;
      
      case "set_quality":
        jwplayer()?.setCurrentQuality(arg);
        break;
    }
  };

  video.onwaiting = () => videoIsBuffering = true;
  video.onplaying = () => videoIsBuffering = false;

  sendData(port, video);
}
      
window.addEventListener("message", event => {
  if (typeof event.data !== "string") {
    return;
  }
  
  let data;
  try {
    data = JSON.parse(event.data);
  } catch (_) {
    return;
  }
  
  if (
    typeof data["channel"] !== "string"
    || data["channel"] !== "nekodroid_player"
    || data["action"] !== "set_port"
    || event.ports[0] == null
    ) {
      return;
    }
    
  main(event.ports[0]);

}, false);
