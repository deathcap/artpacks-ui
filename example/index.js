'use strict';

var createArtPacks = require('artpacks');
var createUI = require('../');

var artPacks = createArtPacks(['ProgrammerArt-ResourcePack.zip', 'F32.zip']);

var ui = createUI(artPacks);

ui.container.style.width = '500px'
document.body.appendChild(ui.container);

var preview = document.createElement('div');
document.body.appendChild(preview);
artPacks.on('refresh', function() {
  while(preview.firstChild) preview.removeChild(preview.firstChild);

  var stone = document.createElement('div');
  preview.appendChild(stone);

  artPacks.getTextureImage('stone', function(img) {
    stone.appendChild(img);
    stone.appendChild(document.createElement('br'));
  }, function(err, img) {
    preview.appendChild(document.createTextNode(''+err));
  });
});
