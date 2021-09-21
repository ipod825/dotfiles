// ==UserScript==
// @name         YouTube Enhancement
// @namespace    https://github.com/ipod825
// @version      0.1
// @description  Some enhancement for youtube
// @author       Shih-Ming Wang
// @match        https://www.youtube.com/*
// ==/UserScript==

'use strict';
const kPanelCls = 'ytctl-panel';
const kSpeedBtnCls = 'ytctl-speed-button';
const kSpeedBtnPressedCls = 'ytctl-speed-button-pressed';
const kDefaultSpeed = 1.8;
const kPlayerID = "movie_player"
var curr_speed = kDefaultSpeed;
var everForground = false;


CSS();
AddPanel();

if(!document.hasFocus()){
    PauseBackgroundTab();
    WaitResumeOnForground();
}

function CSS() {
    let sheet = document.createElement('style')
    sheet.innerHTML =
    `.${kPanelCls} {
        opacity: 0.01;
        position: relative;
        background: #D1D1D1;
        margin:  10% 0 0 90%;
        font-size:  2em;
        z-index: 999;
    }
    .${kPanelCls}:hover {
        opacity: 0.8;
    }
    .${kSpeedBtnCls} {
        display: block;
        font-weight: normal;
        color:  grey;
    }
    .${kSpeedBtnPressedCls} {
        display: block;
        font-weight: bold;
        color: black;
    }
    `;
    document.head.appendChild(sheet);
}

function SpeedBtnId(speed) {
    return kSpeedBtnCls + "-" + speed;
}

function SetSpeed(speed) {
    document.getElementsByClassName('html5-main-video')[0].playbackRate = speed;
    curr_speed = speed;
}

function AddSpeedBtn(panel, speed) {
    let spdBtn = document.createElement("div");
    spdBtn.classList.add(kSpeedBtnCls);
    spdBtn.id = SpeedBtnId(speed);
    spdBtn.onclick = function() {
        Array.from(document.getElementsByClassName(kSpeedBtnCls)).forEach(curr =>{
            curr.classList.remove(kSpeedBtnPressedCls);
        });
        this.classList.add(kSpeedBtnPressedCls);
        SetSpeed(speed)
    };
    let label = document.createTextNode(speed + "x");
    spdBtn.appendChild(label);
    panel.appendChild(spdBtn);
}

function AddPanel (trial=0) {
    let player = document.getElementById(kPlayerID);
    if (!player){
        setTimeout(()=> AddPanel(trial+1), Math.max(10 * trial, 2000));
        return;
    }
    let panel = document.createElement("div");
    panel.classList = kPanelCls;
    AddSpeedBtn(panel, 1);
    AddSpeedBtn(panel, 1.25);
    AddSpeedBtn(panel, 1.5);
    AddSpeedBtn(panel, 1.75);
    AddSpeedBtn(panel, 1.8);
    AddSpeedBtn(panel, 2);
    AddSpeedBtn(panel, 10);
    player.appendChild(panel, player.childNodes[0]);
    document.getElementById(SpeedBtnId(kDefaultSpeed)).click();
}

function PauseBackgroundTab(){
    if(!everForground){
        let player = document.getElementById(kPlayerID);
        player.pauseVideo();
        setTimeout(PauseBackgroundTab, 100);
    }
}

function WaitResumeOnForground(){
    if(!everForground){
        if(document.hasFocus()){
            let player = document.getElementById(kPlayerID);
            everForground = true;
            player.playVideo();
        }
        else{
            setTimeout(WaitResumeOnForground, 100);
        }
    }
}

// https://greasyfork.org/ru/scripts/386925-youtube-ad-cleaner-include-non-skippable-ads-works/code
setInterval(adMonitor ,500);
setInterval(killAd ,1);
setInterval(()=>{counter = 0; console.log("Counter is reset by timer");} ,60000);
window.addEventListener("click", ()=>{setTimeout(()=>{counter = 0; console.log("Counter is reset by mouse click");},2000);});
var counter = 0;
var fixLoopInvoked = false;

function adMonitor()
{
    if (fixLoopInvoked){fixLoopInvoked=false;}
    try
    {
      let ytplayer = document.getElementById("movie_player");
      let adState = ytplayer.getAdState();
      if (adState === 1)
      {
          counter +=1;
          Ads.cancelVdoAd();
          if (ytplayer.getPlayerState() === -1) Ads.stopVdoAd();
          console.log("Current counter is:" + counter);
          if (counter >=2) {counter=0;console.log("Invoked fixLoop");fixLoopInvoked = true;Ads.fixLoop();}; //remove stubbon video ad
      }
    }
    catch(e)
    {
        return;
    }
}

function killAd()
{
    Ads.removeByID();
    Ads.removeByClassName();
    Ads.removeByTagName();
}

var Ads = {
    "aId":["masthead-ad","player-ads","top-container","offer-module","pyv-watch-related-dest-url","ytd-promoted-video-renderer"],
    "aClass":["style-scope ytd-search-pyv-renderer","video-ads","ytd-compact-promoted-video-renderer"],
    "aTag":["ytd-promoted-sparkles-text-search-renderer"],
    "removeByID":function(){this.aId.forEach(i=>{ var AdId = document.getElementById(i);if(AdId) AdId.remove();})},
    "removeByClassName":function(){this.aClass.forEach(c=>{ var AdClass = document.getElementsByClassName(c);if(AdClass[0]) AdClass[0].remove();})},
    "removeByTagName":function(){this.aTag.forEach(t=>{ var AdTag = document.getElementsByTagName(t);if(AdTag[0]) AdTag[0].remove();})},
    "cancelVdoAd":function(){ console.log('cancelled video ad'); document.getElementById("movie_player").cancelPlayback();setTimeout(()=>{document.getElementById("movie_player").playVideo();},1);},
    "stopVdoAd":function(){ console.log('stopped video ad'); document.getElementById("movie_player").stopVideo();setTimeout(()=>{document.getElementById("movie_player").playVideo();},1);},
    "fixLoop":function(){console.log('fixLoop is triggered');let myWin = window.open('', '_blank');myWin.document.write("<script>function closeIt(){window.close();} window.onload=setTimeout(closeIt, 1000);<\/script><p>Skipping Ad ... auto close!!<\/p>");myWin.focus();}
}
