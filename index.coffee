
module.exports = (artPacks) -> new APSelector(artPacks)

class APSelector
  constructor: (@artPacks) ->
    @container = document.createElement 'div'

    for pack in @artPacks.packs
      continue if not pack?

      node = document.createTextElement pack.toString()
      @container.appendChild node


