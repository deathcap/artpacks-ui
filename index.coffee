
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

      node = document.createTextNode pack.toString()
      @container.appendChild node


