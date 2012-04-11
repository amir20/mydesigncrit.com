class Project
  constructor: (@id, @gridline = new GridLine(), @canvas = ($ '#canvas'), @tools = ($ '#sidebar')) ->
    @crits = []
    ($ document).on mousedown: @onNewCrit
    @load() if @id?


  onNewCrit: (e) =>
    if e.target in @gridline.lines or e.target is @canvas.get()
      e.preventDefault()
      @gridline.hide()
      @crits.push new Crit(
        num: @crits.length + 1
        tools: @tools
        canvas: @canvas
        gridline: @gridline
        x: e.pageX - @canvas.offset().left
        y: e.pageY - @canvas.offset().top
        callback: (crit) =>
          @persist()
      )

  persist: ->
    crits = []
    for c in @crits
      crits.push c.toArray()
    $.post('', crits: crits)

  load: ->
    $.get(document.location + '.json').success (project) =>
      for array in project.crits
        @crits.push new Crit(num: @crits.length + 1, tools: @tools, canvas: @canvas, gridline: @gridline, array: array)

window.Project = Project
