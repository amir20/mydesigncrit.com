class Project
  constructor: (@id, @readOnly = false, @onReady = -> ) ->
    @gridline = new GridLine()
    @canvas = ($ '#canvas')
    @sidebar = ($ '#sidebar')
    @crits = []
    @load()
    if !@readOnly
      ($ document).on mousedown: @onNewCrit
      ($ '#save-crit').on click: @saveCurrentCrit
      ($ '#remove-crit').on click: @removeCurrentCrit
      ($ '#cancel-crit').on click: @cancelCurrentCrit
      ($ '#remove-all').on click: @removeAll


  onNewCrit: (e) =>
    if e.which == 1 && (e.target in @gridline.lines or e.target in @canvas.get())
      e.preventDefault()
      @gridline.disable(false)
      @crits.push new Crit(
        project: this
        sidebar: @sidebar
        canvas: @canvas
        gridline: @gridline
        event: e
        callback: (crit) =>
          @sidebar.find('.placeholder').hide().end().find('#remove-all').show()
          @gridline.enable(false)
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
    ($ '#crit-comment').focus()

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
    @toggleOptions(false)
    @crits.splice(@crits.indexOf(critToRemove), 1)
    crit.updateNum i + 1 for crit, i in @crits
    @persist()

  removeAll: =>
    @crits = []
    ($ '#crits > li, #canvas .crit').not('.placeholder').remove().end().filter('.placeholder').show()
    ($ '#remove-all').hide()
    @persist()

  persist: ->
    if !@readOnly
      crits = []
      for c in @crits
        crits.push c.toArray()
      $.post('', crits: crits)

  load: ->
    $.get("/edit/#{@id}.json").success (project) =>
      if project.crits? && project.crits.length > 0
        @sidebar.find('.placeholder').hide().end().find('#remove-all').show()
        for c in project.crits
          @crits.push new Crit(project: this, sidebar: @sidebar, canvas: @canvas, gridline: @gridline, array: c, readOnly: @readOnly)
      @onReady(this)

window.Project = Project
