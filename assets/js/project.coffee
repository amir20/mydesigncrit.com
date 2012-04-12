class Project
  constructor: (@id, @gridline = new GridLine(), @canvas = ($ '#canvas'), @sidebar = ($ '#sidebar')) ->
    @crits = []
    ($ document).on mousedown: @onNewCrit
    @load() if @id?

  onNewCrit: (e) =>
    if e.target in @gridline.lines or e.target in @canvas.get()
      e.preventDefault()
      @gridline.hide()
      @sidebar.find('.placeholder').remove()
      @crits.push new Crit(
        project: this
        sidebar: @sidebar
        canvas: @canvas
        gridline: @gridline
        event: e
        callback: (crit) =>
          @persist()
      )
  remove: (critToRemove) ->
    @crits.splice(@crits.indexOf(critToRemove), 1)
    crit.updateNum i + 1 for crit, i in @crits
    @persist()

  persist: ->
    crits = []
    for c in @crits
      crits.push c.toArray()
    $.post('', crits: crits)

  load: ->
    $.get(document.location + '.json').success (project) =>
      @sidebar.find('.placeholder').remove() if project.crits.length > 0
      for array in project.crits
        @crits.push new Crit(project: this, sidebar: @sidebar, canvas: @canvas, gridline: @gridline, array: array)

window.Project = Project
