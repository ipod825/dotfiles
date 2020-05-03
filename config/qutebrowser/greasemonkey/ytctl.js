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
const kDefaultSpeed = 2;
const kPlayerID = "movie_player"
var curr_speed = kDefaultSpeed;
var everForground = false;


CSS();
AddPanel();
setInterval(KillStaticAd ,50);
setInterval(KillVdoAd ,10);

if(!document.hasFocus()){
    PauseBackgroundTab();
    WaitResumeOnForground();
}

function KillVdoAd () {
    var classForOnlyVideoAds = 'ytp-ad-player-overlay'; // .video-ads at the top level also includes footer ads
    var [adContainer] = document.getElementsByClassName(classForOnlyVideoAds);
    const isAdHidden = !adContainer || adContainer.offsetParent === null;
    if (!isAdHidden){
        player.stopVideo();
        setTimeout(()=>{
            player.playVideo();
            SetSpeed(curr_speed);
        }, 1);
    }
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
        cursor: all-scroll;
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

function KillStaticAd() {
    Ads.removeByID();
    Ads.removeByClassName();
    Ads.removeByTagName();
}

var Ads = {
    "aId":["masthead-ad","player-ads","top-container","offer-module","pyv-watch-related-dest-url","ytd-promoted-video-renderer"],
    "aClass":["style-scope ytd-search-pyv-renderer","video-ads","ytd-compact-promoted-video-renderer"],
    "aTag":["ytd-promoted-sparkles-text-search-renderer"],
    "removeByID":function(){this.aId.forEach(i=>{ let AdId = document.getElementById(i);if(AdId) AdId.remove();})},
    "removeByClassName":function(){this.aClass.forEach(c=>{ let AdClass = document.getElementsByClassName(c);if(AdClass[0]) AdClass[0].remove();})},
    "removeByTagName":function(){this.aTag.forEach(t=>{ let AdTag = document.getElementsByTagName(t);if(AdTag[0]) AdTag[0].remove();})},
}
