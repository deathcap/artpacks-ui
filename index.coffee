
module.exports = (artPacks) -> new APSelector(artPacks)

class APSelector
  constructor: (@artPacks, opts) ->
    @container = document.createElement 'div'
    @draggingIndex = undefined
    
    opts ?= {}
    @logoSize = opts.logoSize ? 64 # natively 128x128

    @enable()

  enable: () ->
    @refresh()
    @artPacks.on 'refresh', @refresh.bind(@)

    document.addEventListener 'dragover', @onDocDragOver.bind(@)
    document.addEventListener 'drop', @onDocDrop.bind(@)

  disable: () ->
    # TODO

  refresh: () ->
    @container.removeChild @container.firstChild while @container.firstChild

    for pack, iReverse in @artPacks.packs.slice(0).reverse()
      i = @artPacks.packs.length - 1 - iReverse

      continue if not pack?

      node = document.createElement 'div'
      node.setAttribute 'draggable', 'true'
      node.setAttribute 'style', '
        border: 1px solid black;
        -webkit-user-select: none;
        -moz-user-select: none;
        cursor: move;
        padding: 10px;
        display: flex;
        align-items: center;
      '
      node.addEventListener 'dragstart', @onDragStart.bind(@, node, i), false
      node.addEventListener 'dragend', @onDragEnd.bind(@, node, i), false
      node.addEventListener 'dragenter', @onDragEnter.bind(@, node, i), false
      node.addEventListener 'dragleave', @onDragLeave.bind(@, node, i), false
      node.addEventListener 'dragover', @onDragOver.bind(@, node, i), false
      node.addEventListener 'drop', @onDrop.bind(@, node, i), false

      logo = new Image()
      logo.src = pack.getPackLogo()
      logo.width = logo.height = @logoSize
      logo.style.paddingRight = '5px' # give some space before text

      node.appendChild logo
      node.appendChild document.createTextNode pack.getDescription()

      @container.appendChild node


  onDragStart: (node, i, ev) ->
    @draggingIndex = i
    node.style.opacity = '0.4'
    ev.dataTransfer.effectAllowed = 'move'
    ev.dataTransfer.setData 'text/plain', ''+i

  onDragEnd: (node, i) ->
    @draggingIndex = undefined
    node.style.opacity = ''


  onDragEnter: (node, i) ->
    return if i == @draggingIndex

    node.style.border = '1px dashed black'

  onDragLeave: (node, i) ->
    return if i == @draggingIndex

    node.style.border = '1px solid black'


  onDragOver: (node, i, ev) ->
    ev.preventDefault()
    ev.dataTransfer.dropEffect = 'move'
  
  onDrop: (node, i, ev) ->
    ev.stopPropagation()
    ev.preventDefault()

    if ev.dataTransfer.files.length != 0
      @addDroppedFiles(ev.dataTransfer.files, i)
    else
      @draggingIndex = +ev.dataTransfer.getData('text/plain')  # note: should be the same
      @artPacks.swap @draggingIndex, i

  addDroppedFiles: (files, at=undefined) ->
    for file in files
      reader = new FileReader()
      reader.addEventListener 'load', (readEvent) =>
        return if readEvent.total != readEvent.loaded # TODO: progress bar
        # always add at beginning
        # TODO: honor 'at', add at specific index
        @artPacks.addPack readEvent.currentTarget.result, file.name

      reader.readAsArrayBuffer(file)


  onDocDragOver: (ev) ->
    ev.preventDefault()   # required to allow dropping
    ev.stopPropagation()

    ev.dataTransfer.dropEffect = 'move'

  onDocDrop: (ev) ->
    if ev.dataTransfer.files.length != 0
      # dropped file somewhere in document - add as first pack
      ev.stopPropagation()
      ev.preventDefault()
      @addDroppedFiles(ev.dataTransfer.files)

