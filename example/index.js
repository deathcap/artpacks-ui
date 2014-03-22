'use strict';

var createArtPacks = require('artpacks');
var createUI = require('../');

var artPacks = createArtPacks(['ProgrammerArt-ResourcePack.zip']);

var ui = createUI(artPacks);
document.body.appendChild(ui.container);
