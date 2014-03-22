
module.exports = (artPacks) -> new APSelector(artPacks)

class APSelector
  constructor: (@artPacks) ->
    @container = document.createElement 'div'

    @refresh()
    @artPacks.on 'loadedAll', @refresh.bind(@)

  refresh: () ->
    @container.removeChild @container.lastChild while @container.lastChild

    for pack in @artPacks.packs
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
      node.addEventListener 'dragstart', @onDragStart.bind(@, node), false
      node.addEventListener 'dragenter', @onDragEnter.bind(@, node), false
      node.addEventListener 'dragover', @onDragOver.bind(@, node), false
      node.addEventListener 'dragleave', @onDragLeave.bind(@, node), false

      @container.appendChild node


  onDragStart: (node) ->

  onDragEnter: (node) ->

  onDragOver: (node) ->

  onDragLeave: (node) ->

