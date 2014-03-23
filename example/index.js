'use strict';

var createArtPacks = require('artpacks');
var createUI = require('../');

var artPacks = createArtPacks(['ProgrammerArt-ResourcePack.zip']);

var ui = createUI(artPacks);

document.body.appendChild(document.createTextNode('Drop a .zip file here to add, or drag and drop the elements below to reorder:'));
document.body.appendChild(document.createElement('br'));
document.body.appendChild(document.createElement('br'));

ui.container.style.width = '500px'
document.body.appendChild(ui.container);

var preview = document.createElement('div');
preview.style.padding = '10px';

document.body.appendChild(preview);
artPacks.on('refresh', function() {
  while(preview.firstChild) preview.removeChild(preview.firstChild);

  ['stone', 'cobblestone', 'dirt', 'grass_top', 'misc/shadow'].forEach(function(name) {
    var node = document.createElement('span');
    node.style.padding = '5px';
    preview.appendChild(node);

    artPacks.getTextureImage(name, function(img) {
      node.appendChild(img);
    }, function(err, img) {
      node.appendChild(document.createTextNode(''+err));
    });
  });

  ['liquid/splash'].forEach(function(name) {
    var node = document.createElement('div');

    var url = artPacks.getSound(name);
    if (url) {
      var audio = document.createElement('audio');
      audio.controls = true;
      audio.title = name;
      audio.src = url;
      node.appendChild(audio);
    } else {
      node.appendChild(document.createTextNode('no such sound: ' + name));
    }

    preview.appendChild(node);
  });
});
