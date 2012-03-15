class GridLine
  constructor: ->
    @h = ($ '.gridline.h')
    @v = ($ '.gridline.v')
    @lines = ($ '.gridline')

    ($ document).on 'mousemove', (e) =>
      $doc = ($ document)
      [left, top] = [e.pageX - $doc.scrollLeft(), e.pageY - $doc.scrollTop()]
      @h.css top: top
      @v.css left: left

  hide: ->
    @lines.hide()

  show: ->
    @lines.show()

window.GridLine = GridLine