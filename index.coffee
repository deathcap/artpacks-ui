
module.exports = (artPacks) -> new APSelector(artPacks)

class APSelector
  constructor: (@artPacks) ->
    @container = document.createElement 'div'
    @draggingIndex = undefined

    @enable()

  enable: () ->
    @refresh()
    @artPacks.on 'refresh', @refresh.bind(@)

    document.addEventListener 'dragenter', @onDocDragEnter.bind(@)
    document.addEventListener 'dragleave', @onDocDragLeave.bind(@)
    document.addEventListener 'dragover', @onDocDragOver.bind(@)
    document.addEventListener 'drop', @onDocDrop.bind(@)

  disable: () ->
    # TODO

  refresh: () ->
    @container.removeChild @container.firstChild while @container.firstChild

    for pack, i in @artPacks.packs
      continue if not pack?

      node = document.createElement 'div'
      node.setAttribute 'draggable', 'true'
      node.setAttribute 'style', '
        border: 1px solid black;
        -webkit-user-select: none;
        -moz-user-select: none;
        cursor: move;
        margin: 10px;
      '
      node.textContent = pack.toString()
      node.addEventListener 'dragstart', @onDragStart.bind(@, node, i), false
      node.addEventListener 'dragend', @onDragEnd.bind(@, node, i), false
      node.addEventListener 'dragenter', @onDragEnter.bind(@, node, i), false
      node.addEventListener 'dragleave', @onDragLeave.bind(@, node, i), false
      node.addEventListener 'dragover', @onDragOver.bind(@, node, i), false
      node.addEventListener 'drop', @onDrop.bind(@, node, i), false

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
      @addDroppedFiles(ev.dataTransfer.files)
    else
      @draggingIndex = +ev.dataTransfer.getData('text/plain')  # note: should be the same
      @artPacks.swap @draggingIndex, i

  addDroppedFiles: (files) ->
    for file in files
      reader = new FileReader()
      reader.addEventListener 'load', (readEvent) =>
        return if readEvent.total != readEvent.loaded # TODO: progress bar
        @artPacks.addPack readEvent.currentTarget.result, file.name

      reader.readAsArrayBuffer(file)


  onDocDragEnter: (ev) ->
    # create dashed outline
    # note: not setting document.body.style.border since shifts document
    @docDragIndicator = document.createElement('div')
    @docDragIndicator.setAttribute 'style', '
      position: absolute;
      top: 0px;
      left: 0px;
      width: 100%;
      height: 100%;
      pointer-events: none;
      border: 5px dashed black;
    '
    # TODO: fix obscured right/bottom border

    document.body.appendChild @docDragIndicator

  onDocDragLeave: (ev) ->
    if @docDragIndicator?
      @docDragIndicator.parentNode.removeChild @docDragIndicator
      @docDragIndicator = undefined

  onDocDragOver: (ev) ->
    ev.preventDefault()
    ev.dataTransfer.dropEffect = 'move'

  onDocDrop: (ev) ->
    ev.stopPropagation()
    ev.preventDefault()
