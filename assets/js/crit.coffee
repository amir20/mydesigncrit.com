BOX_TEMPLATE = jade.compile '''
.crit
  a.close.show-after &times;
  a.resize-anchor.show-after
  label
   .num(style='background-color: #{color}') #{num}
   .arrow(style='border-left-color: #{color}')
  .comment
'''

LIST_TEMPLATE = jade.compile '''
li(style='color: #{color}')
  a.close &times;
  a.title(style='color: #{color}') #{title}
'''
COLORS = ['#9d91e7', '#fb4c2f', '#42d692', '#4986e7', '#c2c2c2', '#b1a07d', '#2da2bb', '#ff7537']

class Crit
  constructor: (@params) ->
    {
    project: @project,
    sidebar: @sidebar,
    gridline: @gridline,
    canvas: @canvas,
    event: event,
    callback: @callback,
    readOnly: @readOnly
    array: array
    } = @params
    @doc = ($ document)
    @num = @project.crits.length + 1
    @color = COLORS[@num % COLORS.length]
    @readOnly ||= false

    # Array is present when loading from ajax
    return @fromArray(array) if array?

    # Get the event from mouse click
    @x = event.pageX - @canvas.offset().left
    @y = event.pageY - @canvas.offset().top

    # Add the container to canvas
    (@container = ($ BOX_TEMPLATE(num: @num, color: @color)).css left: @x, top: @y).appendTo @canvas
    @container.addClass 'hover'

    @doc.one mouseup: (e) =>
      @container.removeClass 'hover'
      @onAfterCreate()
      @callback(this) if @callback

    @doc.on mousemove: @onResize

  # Gets called after a crit has been created
  onAfterCreate: =>
    @doc.off mousemove: @onResize
    @container.find('label').show()
    unless @readOnly
      @container.find('.show-after').removeClass('show-after')
      @createListItem()
      @attachEvents()

  createListItem: =>
    @listItem = ($ LIST_TEMPLATE(num: @num, title: 'Untitled', color: @color)).appendTo(@sidebar.find('#crits'))
    @listItem.find('.close').on click: => @project.remove(this)
    @listItem.find('a.title').on(
      click: => @project.select(this)
      mouseover: @onListItemMouseover
      mouseout: @onListItemMouseout
    ).text(@comment)

  attachEvents: =>
    @container.on mouseenter: (=> @gridline.hide()), mouseleave: (=> @gridline.show())
    @container.find('.close').on click: => @project.remove(this)
    @container.on
      click: => @project.select(this) if @clickFlag?
      mousedown: @onContainerMouseDown
    @container.find('a.resize-anchor').on
      mousedown: (e) =>
        e.stopPropagation()
        e.preventDefault()
        @gridline.hide(true)
        @container.addClass 'hover'
        @doc.on mousemove: @onResize
      mouseup: =>
        @doc.off mousemove: @onResize
        @container.removeClass 'hover'
        @gridline.show(true)
        @project.persist()

  onResize: (e) =>
    e.preventDefault()
    @container.width(e.pageX - @x - @canvas.offset().left).height(e.pageY - @y - @canvas.offset().top)

  onMove: (e) =>
    e.preventDefault()
    @x = @beforeMove.x + e.pageX - @beforeMove.e.pageX
    @y = @beforeMove.y + e.pageY - @beforeMove.e.pageY
    @container.css left: @x, top: @y

  onContainerMouseDown: (e) =>
    e.preventDefault()
    @doc.on mousemove: @onMove
    @beforeMove = x: @x, y: @y, e: e
    @clickFlag = true
    setTimeout (=> @clickFlag = null), 300
    @doc.one mouseup: =>
      @doc.off mousemove: @onMove
      @project.persist()

  onListItemMouseover: =>
    @container.addClass('hover')

  onListItemMouseout: =>
    @container.removeClass('hover')

  remove: =>
    @container.remove()
    @listItem.remove()

  edit: =>
    ($ '#crit-comment').val(@comment)
    @container.addClass('active')
    $('html,body').animate(scrollTop: @container.offset().top - 100, 'fast') unless @container.is(':in-viewport')

  cancel: ->
    @container.removeClass('active')

  save: ->
    @comment = ($ '#crit-comment').val()
    @listItem.find('a.title').text(@comment)
    @container.removeClass('active')
    @project.persist()

  updateNum: (i) ->
    @container.find('.num').text(i)
    @num = i
    @color = COLORS[@num % COLORS.length]
    @container.find('.num').css('background-color': @color).end().find('.arrow').css('border-left-color': @color).end()
    @listItem.css(color: @color).find('a.title').css(color: @color)
    @listItem.find('a.title').on click: @edit

  toArray: -> { x: @x, y: @y, width: @container.width(), height: @container.height(), comment: @comment }

  fromArray: (array) ->
    @x = array.x
    @y = array.y
    @comment = array.comment
    (@container = ($ BOX_TEMPLATE(num: @num, color: @color)).css left: @x, top: @y).appendTo(@canvas).width(array.width).height(array.height)
    @onAfterCreate()
    return this

window.Crit = Crit
