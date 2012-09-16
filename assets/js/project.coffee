PAGES_DROPDOWN = jade.compile '''
- each page in project.pages
  li
    a(title=page.title, data-page-id=page._id, href='#')
     i.icon-file 
     | #{page.title}    
'''

class Project
  constructor: (@readOnly = false, @onReady = ->) ->
    @pages = []
    @pagesById = []    
    @canvas = ($ '#canvas')
    @sidebar = ($ '#sidebar')
    @prev = ($ '#prev-page')
    @next = ($ '#next-page')
    @history = new History(/^\/.+?\/.+?\/(.+)$/, @onShowPage)
    @load()

    @next.on click: @nextPage
    @prev.on click: @prevPage
    ($ '#active-page + ul.dropdown-menu').on 'click', 'li > a', (e) =>
      e.preventDefault()
      @showPage(($ e.target).data('page-id'))
      
    unless @readOnly
      ($ document).on mousedown: @onNewCrit
      ($ '#save-crit').on click: @saveCurrentCrit
      ($ '#remove-crit').on click: @removeCurrentCrit
      ($ '#cancel-crit').on click: @cancelCurrentCrit
      ($ '#remove-all').on click: @removeAll
      ($ '#new-page').on submit: @onNewPage          

  showPage: (pageId) ->
    @activePage = @pagesById[pageId]
    @history.load("/#{@base}/#{@id}/#{pageId}")

  nextPage: =>
    activeIndex = @pages.indexOf @activePage
    @showPage(@pages[activeIndex + 1].id) if @pages[activeIndex + 1]?

  prevPage: =>
    activeIndex = @pages.indexOf @activePage
    @showPage(@pages[activeIndex - 1].id) if activeIndex > 0
    
  onShowPage: (pageId) =>
    pageId = pageId or @firstPageId()
    @clearCrits()
    @clearSidebar()
    @showPlaceHolder()
    (@activePage = @pagesById[pageId]).show()
    document.title = "myDesignCrit.com - #{@activePage.title}"
    ($ '#active-page i').text(@activePage.title)    
    activeIndex = @pages.indexOf @activePage
    if @pages[activeIndex + 1]? then @next.removeClass 'disabled' else @next.addClass 'disabled'
    if activeIndex > 0 then @prev.removeClass 'disabled' else @prev.addClass 'disabled'

  firstPageId: ->
    @pages[0].id

  onNewCrit: (e) =>
    @activePage.onNewCrit(e)

  saveCurrentCrit: (e) =>
    @activePage.saveCurrentCrit(e)
    @toggleOptions(false)
    ($ '#crit-comment').val('')

  removeCurrentCrit: (e) =>
    @activePage.removeCurrentCrit(e)
    @toggleOptions(false)

  cancelCurrentCrit: (e) =>
    @activePage.cancelCurrentCrit(e)
    @toggleOptions(false)

  removeAll: (e) =>
    @activePage.removeAll(e)
    @clearCrits()
    @clearSidebar()
    @showPlaceHolder()

  clearSidebar: ->
    ($ '#crits > li', @sidebar).not('.placeholder').remove()

  clearCrits: ->    
    ($ '.crit', @canvas).remove()

  hidePlaceHolder: ->
    @sidebar.find('.placeholder').hide().end().find('#remove-all').show()

  showPlaceHolder: ->
    @sidebar.find('.placeholder').show().end().find('#remove-all').hide()

  onNewPage: (e) =>
    e.preventDefault()
    @addingNewPage = true
    showLoader()
    ($ 'form#new-page .popbox-close').click()
    $.post("/edit/#{@id}", newPageUrl: ($ 'form#new-page input[type=url]').val(), @onLoad)
    ($ 'form#new-page input[type=url]').val('')

  toggleOptions: (options) ->
    if options
      ($ '#crit-list').hide()
      ($ '#crit-options').show()
    else
      ($ '#crit-list').show()
      ($ '#crit-options').hide()

  load: ->
    showLoader()
    $.get("#{location.pathname}.json").success @onLoad

  onLoad: (project) =>
    @pages = []
    @pagesById = []    
    @pages.push new Page(this, page) for page in project.pages
    @pagesById[page.id] = page for page in @pages
    [t, @base, @id, pageId] = location.pathname.split('/')        
    ($ '#active-page + ul.dropdown-menu').html(PAGES_DROPDOWN(project: project))
    
    if @addingNewPage 
      @showPage(project.pages[project.pages.length - 1]._id)
    else
      @onShowPage(pageId)
      @onReady(this)
      
    removeLoader()    
    

window.Project = Project
