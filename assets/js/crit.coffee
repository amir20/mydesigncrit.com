BOX_TEMPLATE = jade.compile '''
.crit
  a.close.show-after &times;
  h4
   .num(style='background-color: #{color}') #{num}
   .arrow(style='border-left-color: #{color}')
'''

LIST_TEMPLATE = jade.compile '''
li(style='color: #{color}')
  a.close &times;
  a.title(style='color: #{color}') #{title}
'''
COLORS = ['#9d91e7','#fb4c2f','#42d692','#4986e7','#c2c2c2','#b1a07d','#2da2bb', '#ff7537']

class Crit
  constructor: (@params) ->
    { project: @project, sidebar: @sidebar, gridline: @gridline, canvas: @canvas, event: event, callback: @callback, array: array } = @params
    @doc = ($ document)
    @num = @project.crits.length + 1
    @color = COLORS[@num % COLORS.length]

    # Array is present when loading from ajax
    return @fromArray(array) if array?

    # Get the event from mouse click
    @x = event.pageX - @canvas.offset().left
    @y = event.pageY - @canvas.offset().top

    # Add the container to canvas
    (@container = ($ BOX_TEMPLATE(num: @num, color: @color)).css left: @x, top: @y).appendTo @canvas

    @doc.one mouseup: (e) =>
      @onAfterCreate()
      @callback(this) if @callback

    @doc.on mousemove: @onResize

  onResize: (e) =>
    @container.width(e.pageX - @x - @canvas.offset().left).height(e.pageY - @y - @canvas.offset().top)

  onAfterCreate: =>
    @doc.off 'mousemove', @onResize
    @container.find('.show-after').removeClass('show-after').end().find('h4').css(opacity: 1)
    @listItem = ($ LIST_TEMPLATE(num: @num, title: 'Untitled', color: @color)).appendTo(@sidebar.find('#crits'))
    @gridline.show()
    @container.on mouseenter: (=> @gridline.hide()), mouseleave: (=> @gridline.show())
    @container.find('.close').on click: @delete
    @listItem.find('.close').on click: @delete

  delete: =>
    @container.remove()
    @listItem.remove()
    @project.remove(this)

  updateNum: (i) ->
    @container.find('.num').text(i)
    @num = i
    @color = COLORS[@num % COLORS.length]
    @container.find('.num').css('background-color': @color).end().find('.arrow').css('border-left-color': @color).end()
    @listItem.css(color: @color).find('a.title').css(color: @color)

  toArray: -> {x: @x, y: @y, width: @container.width(), height: @container.height(), message: @message}

  fromArray: (array) ->
    @x = array.x
    @y = array.y
    @message - array.message
    (@container = ($ BOX_TEMPLATE(num: @num, color: @color)).css left: array.x, top: array.y).appendTo(@canvas).width(array.width).height(array.height)
    @onAfterCreate()
    return this

window.Crit = Crit
