$ ->
  gridline = new GridLine()
  $canvas = $('#canvas')
  if notEmpty $canvas
    toHandle = $('#canvas, .gridline').get()
    ($ document).on 'mousedown', (e) ->
      if e.target in toHandle
        e.preventDefault()
        gridline.hide()
        new Crit($canvas, e.pageX - $canvas.position().left, e.pageY - $canvas.position().top, -> gridline.show())
