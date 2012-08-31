class Project
  constructor: (@readOnly = false, @onReady = ->) ->
    @pages = []
    @load()

  showPage: (id) ->
    @history.load("/#{@base}/#{@projectId}/#{id}")

  firstPageId: ->
    return id for id of @pages

  load: ->
    $.get("#{location.pathname}.json").success (project) =>
      @projectId = project._id
      @base = location.pathname.split('/')[1]
      @pages[page._id] = new Page(this, page) for page in project.pages
      @history = new History(/^\/.+?\/.+?\/(.+)$/, (pageId) => @pages[pageId].show())
      pageId = @history.getHistoryPath()
      @showPage(if !!pageId then pageId else @firstPageId())
      @onReady(this)

window.Project = Project
