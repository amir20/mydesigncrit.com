class GridLine
  constructor: ->
    @h = ($ '.gridline.h')
    @v = ($ '.gridline.v')
    @lines = ($ '.gridline')
    @enabled = true

    ($ document).on 'mousemove', (e) =>
      $doc = ($ document)
      [left, top] = [e.pageX - $doc.scrollLeft(), e.pageY - $doc.scrollTop()]
      @h.css top: top
      @v.css left: left

    ($ '#toggle-gridlines').on click: @toggle

  hide: ->
    @lines.hide()

  show: ->
    @lines.show() if @enabled

  toggle: =>
    if @enabled then @disable() else @enable()

  disable: ->
    @hide()
    ($ '#toggle-gridlines').html('<i class="icon-ok-circle"></i> Show Grid Lines')
    @enabled = false

  enable: ->
    ($ '#toggle-gridlines').html('<i class="icon-ban-circle"></i> Hide Grid Lines')
    @enabled = true
    @show()

window.GridLine = GridLine