
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
      node.setAttribute 'style', '
        border: 1px solid black;
        -webkit-user-select: none;
        -moz-user-select: none;
        cursor: crosshair;
      '
      node.textContent = pack.toString()
      @container.appendChild node


