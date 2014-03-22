
module.exports = (artPacks) -> new APSelector(artPacks)

class APSelector
  constructor: (@artPacks) ->
    @container = document.createElement 'div'
    @draggingIndex = undefined

    @refresh()
    @artPacks.on 'loadedAll', @refresh.bind(@)

  refresh: () ->
    @container.removeChild @container.lastChild while @container.lastChild

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
    @draggingIndex = +ev.dataTransfer.getData('text/plain')  # note: should be the same

    # swap @draggingIndex (source) and i (dest)
    console.log 'swap',@draggingIndex,i
    temp = @artPacks.packs[@draggingIndex]
    @artPacks.packs[@draggingIndex] = @artPacks.packs[i]
    @artPacks.packs[i] = temp

    @refresh()

