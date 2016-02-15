'use strict';

module.exports = (artPacks) => new APSelector(artPacks);

class APSelector {
  constructor(artPacks, opts) {
    this.artPacks = artPacks;
    this.container = document.createElement('div');
    this.draggingIndex = undefined;

    if (!opts) opts = {};
    this.logoSize = opts.logoSize !== undefined ? opts.logoSize : 64; // natively 128x128

    this.enable();
  }

  enable() {
    this.refresh();
    this.artPacks.on('refresh', this.refresh.bind(this));

    document.addEventListener('dragover', this.onDocDragOver.bind(this));
    document.addEventListener('drop', this.onDocDrop.bind(this));
  }

  disable() {
    // TODO
  }

  refresh() {
    while(this.container.firstChild) {
      this.container.removeChild(this.container.firstChild);
    }

    const reversedPacks = this.artPacks.packs.slice(0).reverse();
    for (let iReverse in reversedPacks) {
      const pack = reversedPacks[iReverse];

      const i = this.artPacks.packs.length - 1 - iReverse;

      if (!pack) continue;

      const node = document.createElement('div');
      node.setAttribute('draggable', 'true');
      node.setAttribute('style', `
        border: 1px solid black;
        -webkit-user-select: none;
        -moz-user-select: none;
        cursor: move;
        padding: 10px;
        display: flex;
        align-items: center;
      `);

      node.addEventListener('dragstart', this.onDragStart.bind(this, node, i), false);
      node.addEventListener('dragend', this.onDragEnd.bind(this, node, i), false);
      node.addEventListener('dragenter', this.onDragEnter.bind(this, node, i), false);
      node.addEventListener('dragleave', this.onDragLeave.bind(this, node, i), false);
      node.addEventListener('dragover', this.onDragOver.bind(this, node, i), false);
      node.addEventListener('drop', this.onDrop.bind(this, node, i), false);

      const logo = new Image();
      logo.src = pack.getPackLogo();
      logo.width = logo.height = this.logoSize;
      logo.style.paddingRight = '5px'; // give some space before text

      node.appendChild(logo);
      node.appendChild(document.createTextNode(pack.getDescription()));

      this.container.appendChild(node);
    }
  }

  onDragStart(node, i, ev) {
    this.draggingIndex = i;
    node.style.opacity = '0.4';
    ev.dataTransfer.effectAllowed = 'move';
    ev.dataTransfer.setData('text/plain', ''+i);
  }

  onDragEnd(node, i) {
    this.draggingIndex = undefined;
    node.style.opacity = '';
  }

  onDragEnter(node, i) {
    if (i === this.draggingIndex) return;

    node.style.border = '1px dashed black';
  }

  onDragLeave(node, i) {
    if (i === this.draggingIndex) return;

    node.style.border = '1px solid black';
  }

  onDragOver(node, i, ev) {
    ev.preventDefault();
    ev.dataTransfer.dropEffect = 'move';
  }
  
  onDrop(node, i, ev) {
    ev.stopPropagation();
    ev.preventDefault();

    if (ev.dataTransfer.files.length !== 0) {
      this.addDroppedFiles(ev.dataTransfer.files, i);
    } else {
      this.draggingIndex = +ev.dataTransfer.getData('text/plain');  // note: should be the same
      this.artPacks.swap(this.draggingIndex, i);
    }
  }

  addDroppedFiles(files, at) {
    //for (let file of files) { // TypeError:  is not a function? (yes its actually blank. Chrome 48)
    for (let i = 0; i < files.length; ++i) {
      const file = files[i];
      let reader = new FileReader();
      reader.addEventListener('load', (readEvent) => {
        if (readEvent.total !== readEvent.loaded) return; // TODO: progress bar
        // always add at beginning
        // TODO: honor 'at', add at specific index
        this.artPacks.addPack(readEvent.currentTarget.result, file.name);
      });

      reader.readAsArrayBuffer(file);
    }
  }

  onDocDragOver(ev) {
    ev.preventDefault();   // required to allow dropping
    ev.stopPropagation();

    ev.dataTransfer.dropEffect = 'move';
  }

  onDocDrop(ev) {
    if (ev.dataTransfer.files.length !== 0) {
      // dropped file somewhere in document - add as first pack
      ev.stopPropagation();
      ev.preventDefault();
      this.addDroppedFiles(ev.dataTransfer.files);
    }
  }
}
