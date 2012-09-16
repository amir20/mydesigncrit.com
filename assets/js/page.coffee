class Page
  constructor: (@project, @json) ->
    @gridline = new GridLine()
    @canvas = ($ '#canvas')
    @sidebar = ($ '#sidebar')
    @title = @json.title
    @id = @json._id
    @crits = []
    for c in @json.crits
      @crits.push new Crit
        page: this
        project: @project
        sidebar: @sidebar
        canvas: @canvas
        gridline: @gridline
        array: c
        readOnly: @project.readOnly

  onNewCrit: (e) =>
    if e.which == 1 and e.target in @canvas.get()
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
          @project.hidePlaceHolder()
          @gridline.enable(false)
          @persist()
          @select(crit)
      )

  select: (crit) ->
    @activeCrit.cancel() if @activeCrit?
    @activeCrit = crit
    @activeCrit.edit()
    @project.toggleOptions(true)
    ($ '#crit-comment').focus()

  saveCurrentCrit: =>
    @activeCrit.save() if @activeCrit?    
    @activeCrit = null

  removeCurrentCrit: =>
    @remove(@activeCrit) if @activeCrit?    
    @activeCrit = null

  cancelCurrentCrit: =>
    @activeCrit.cancel() if @activeCrit?    
    @activeCrit = null

  remove: (critToRemove) ->
    critToRemove.remove()
    @project.toggleOptions(false)
    @crits.splice(@crits.indexOf(critToRemove), 1)
    crit.updateNum(i + 1) for crit, i in @crits
    @persist()

  removeAll: =>
    @crits = []        
    @persist()

  persist: ->
    unless @readOnly
      crits = []      
      crits.push c.toArray() for c in @crits
      $.post('', crits: crits)

  show: ->    
    @canvas.empty().css('background-image': "url(#{@json.screenshot})", width: @json.screenshotWidth, height: @json.screenshotHeight)
    if (@json.crits? && @json.crits.length > 0) or (@crits.length > 0)
      @project.hidePlaceHolder()
      crit.show() for crit in @crits
      if @activeCrit then @select(@activeCrit) else @cancelCurrentCrit()     

window.Page = Page
