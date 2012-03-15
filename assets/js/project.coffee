$ ->

  $canvas = $('#canvas')
  if $canvas.length?
    toHandle = $('#canvas, .gridline').get()
    mouseDownEvent = null
    crit = null
    $(document).mousedown( (e) ->
      if e.target in toHandle
        e.preventDefault()
        mouseDownEvent = e
        crit = $('<div />', 'class': 'crit').css left: e.pageX, top: e.pageY
        crit.appendTo $canvas
    ).mouseup( (e) ->
      mouseDownEvent = null
    ).mousemove (e) ->
      if mouseDownEvent?
        width = e.pageX - mouseDownEvent.pageX
        height = e.pageY - mouseDownEvent.pageY
        crit.width(width).height(height)
