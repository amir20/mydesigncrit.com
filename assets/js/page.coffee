class Page
  constructor: (@project, @json) ->
    @gridline = new GridLine()
    @canvas = ($ '#canvas')
    @sidebar = ($ '#sidebar')

  onNewCrit: (e) =>
    if e.which == 1 && (e.target in @gridline.lines or e.target in @canvas.get())
      e.preventDefault()
      @gridline.disable(false)
      @crits.push new Crit(
        project: @project
        page: this
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
    unless @readOnly
      crits = []
      for c in @crits
        crits.push c.toArray()
      $.post('', crits: crits)

  show: ->
    @canvas.empty()
    @canvas.css('background-image': "url(#{@json.screenshot})", width: @json.screenshotWidth, height: @json.screenshotHeight)
    if @json.crits? && @json.crits.length > 0
      @sidebar.find('.placeholder').hide().end().find('#remove-all').show()
      for c in @json.crits
        @crits.push new Crit
          page: this
          project: @project
          sidebar: @sidebar
          canvas: @canvas
          gridline: @gridline
          array: c
          readOnly: @project.readOnly

window.Page = Page
