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

  ['stone', 'cobblestone', 'dirt', 'grass_top'].forEach(function(name) {
    var node = document.createElement('span');
    node.style.padding = '5px';
    preview.appendChild(node);

    artPacks.getTextureImage(name, function(img) {
      node.appendChild(img);
    }, function(err, img) {
      node.appendChild(document.createTextNode(''+err));
    });
  });
});
