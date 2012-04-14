class Project
  constructor: (@id, @gridline = new GridLine(), @canvas = ($ '#canvas'), @sidebar = ($ '#sidebar')) ->
    @crits = []
    ($ document).on mousedown: @onNewCrit
    @load() if @id?
    ($ '#save-crit').on click: @saveCurrentCrit
    ($ '#remove-crit').on click: @removeCurrentCrit
    ($ '#cancel-crit').on click: @cancelCurrentCrit


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
          @select(crit)
      )

  toggleOptions: (options)->
    if options
      ($ '#crit-list').hide()
      ($ '#crit-options').show()
    else
      ($ '#crit-list').show()
      ($ '#crit-options').hide()

  select: (crit) ->
    @activeCrit.cancel() if @activeCrit?
    @activeCrit = crit
    @activeCrit.edit()
    @toggleOptions(true)

  saveCurrentCrit: =>
    @activeCrit.save() if @activeCrit?
    @toggleOptions(false)
    ($ '#crit-comment').val('')
    @activeCrit = null

  removeCurrentCrit: =>
    @remove(@activeCrit) if @activeCrit?
    @toggleOptions(false)
    @activeCrit = null

  cancelCurrentCrit: =>
    @activeCrit.cancel() if @activeCrit?
    @toggleOptions(false)
    @activeCrit = null

  remove: (critToRemove) ->
    critToRemove.remove()
    @crits.splice(@crits.indexOf(critToRemove), 1)
    crit.updateNum i + 1 for crit, i in @crits
    @persist()

  removeAll: ->
    @crits = []
    ($ '#crits > li, #canvas .crit').remove()
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
