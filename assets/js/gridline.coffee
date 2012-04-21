class GridLine
  constructor: ->
    @h = ($ '.gridline.h')
    @v = ($ '.gridline.v')
    @lines = ($ '.gridline')
    @enabled = true
    @locked = false

    ($ document).on mousemove: (e) =>
      $doc = ($ document)
      [left, top] = [e.pageX - $doc.scrollLeft(), e.pageY - $doc.scrollTop()]
      @h.css top: top
      @v.css left: left

    ($ '#toggle-gridlines').on click: @toggle

  hide: (aquire = false) ->
    @locked = true if aquire
    @lines.hide() if !@locked

  show: (release = false) ->
    @locked = false if release
    @lines.show() if !@locked and @enabled

  toggle: =>
    if @enabled then @disable() else @enable()

  disable:(updateButton = true) ->
    @hide()
    ($ '#toggle-gridlines').html('<i class="icon-ok-circle"></i> Show Grid Lines') if updateButton
    @enabled = false

  enable: (updateButton = true) ->
    ($ '#toggle-gridlines').html('<i class="icon-ban-circle"></i> Hide Grid Lines') if updateButton
    @enabled = true
    @show()

window.GridLine = GridLine