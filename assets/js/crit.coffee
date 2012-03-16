TEMPLATE = jade.compile '''
.crit
  h4
   .num #{num}
   .arrow
'''
COLORS = ['#9d91e7','#fb4c2f','#42d692','#4986e7','#c2c2c2','#b1a07d','#2da2bb', '#ff7537']
CRITS = []
class Crit
  constructor: (@canvas, @x, @y, @callback = null) ->
    CRITS.push this
    (@container = ($ TEMPLATE(num: CRITS.length)).css left: @x, top: @y).appendTo @canvas
    @doc = ($ document)

    @doc.one 'mouseup', (e) =>
      @onAfterCreate()
      @callback(this) if @callback

    @doc.on 'mousemove', @onResize

  onResize: (e) =>
    @container.width(e.pageX - @x - @canvas.position().left).height(e.pageY - @y - @canvas.position().top)

  onAfterCreate: (e) =>
    @doc.off 'mousemove', @onResize
    color = COLORS[(CRITS.length - 1) % COLORS.length]
    @container.find('.num').css('background-color': color).end()
              .find('.arrow').css('border-left-color': color).end()
              .find('h4').css opacity: 1


window.Crit = Crit
