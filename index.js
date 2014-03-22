// Generated by CoffeeScript 1.7.0
(function() {
  var APSelector;

  module.exports = function(artPacks) {
    return new APSelector(artPacks);
  };

  APSelector = (function() {
    function APSelector(artPacks) {
      var node, pack, _i, _len, _ref;
      this.artPacks = artPacks;
      this.container = document.createElement('div');
      _ref = this.artPacks.packs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pack = _ref[_i];
        if (pack == null) {
          continue;
        }
        node = document.createTextElement(pack.toString());
        this.container.appendChild(node);
      }
    }

    return APSelector;

  })();

}).call(this);