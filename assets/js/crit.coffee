class Crit
  constructor: (@canvas, @x, @y, @callback = null) ->
    (@container = $('<div />', 'class': 'crit').css left: @x, top: @y).appendTo @canvas
    @doc = ($ document)

    @doc.one 'mouseup', (e) =>
      @onAfterCreate()
      @callback(this) if @callback

    @doc.on 'mousemove', @onResize

  onResize: (e) =>
    @container.width(e.pageX - @x).height(e.pageY - @y)

  onAfterCreate: (e) =>
    @doc.off 'mousemove', @onResize

window.Crit = Crit
