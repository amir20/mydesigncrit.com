BOX_TEMPLATE = jade.compile '''
.crit
  h4
   .num #{num}
   .arrow
'''

LIST_TEMPLATE = jade.compile '''
li
  span.icon
  span.title #{title}
'''
COLORS = ['#9d91e7','#fb4c2f','#42d692','#4986e7','#c2c2c2','#b1a07d','#2da2bb', '#ff7537']

class Crit
  constructor: (@params) ->
    { num: @num, tools: @tools, gridline: @gridline, canvas: @canvas, x: @x, y: @y, callback: @callback, array: array} = @params
    @doc = ($ document)

    return @fromArray(array) if array?

    (@container = ($ BOX_TEMPLATE(num: @num)).css left: @x, top: @y).appendTo @canvas
    @doc.one mouseup: (e) =>
      @onAfterCreate()
      @callback(this) if @callback

    @doc.on mousemove: @onResize

  onResize: (e) =>
    @container.width(e.pageX - @x - @canvas.offset().left).height(e.pageY - @y - @canvas.offset().top)

  onAfterCreate: =>
    @doc.off 'mousemove', @onResize
    color = COLORS[@num % COLORS.length]
    @container.find('.num').css('background-color': color).end()
              .find('.arrow').css('border-left-color': color).end()
              .find('h4').css opacity: 1

    @tools.find('.placeholder').hide()
    @listItem = ($ LIST_TEMPLATE(num: @num, title: 'Untitled')).appendTo(@tools.find('#crits'))
    setTimeout (=> @listItem.css('background-color': color)), 1
    @gridline.show()
    @container.on mouseenter: (=> @gridline.hide()), mouseleave: (=> @gridline.show())


  toArray: -> {x: @x, y: @y, width: @container.width(), height: @container.height(), message: @message}

  fromArray: (array) ->
    @x = array.x
    @y = array.y
    @message - array.message
    (@container = ($ BOX_TEMPLATE(num: @num)).css left: array.x, top: array.y).appendTo(@canvas).width(array.width).height(array.height)
    @onAfterCreate()
    return this

window.Crit = Crit
