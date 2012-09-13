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
    @canvas = ($ '#canvas')
    @sidebar = ($ '#sidebar')
    @history = new History(/^\/.+?\/.+?\/(.+)$/, @onShowPage)
    @load()

    ($ document).on mousedown: @onNewCrit
    ($ '#save-crit').on click: @saveCurrentCrit
    ($ '#remove-crit').on click: @removeCurrentCrit
    ($ '#cancel-crit').on click: @cancelCurrentCrit
    ($ '#remove-all').on click: @removeAll
    ($ '#new-page').on submit: @onNewPage
    ($ '#active-page + ul.dropdown-menu').on 'click', 'li > a', (e) =>
      e.preventDefault()      
      @showPage(($ e.target).data('page-id')) 

  showPage: (pageId) ->   
    @activePage = @pages[pageId]
    @history.load("/#{@base}/#{@id}/#{pageId}")

  onShowPage: (pageId) =>
    @clearCrits
    @clearSidebar()
    @showPlaceHolder()
    @pages[pageId].show()
    document.title = "myDesignCrit.com - #{@activePage.title}"
    ($ '#active-page i').text(@activePage.title)    

  firstPageId: ->
    return id for id of @pages

  onNewCrit: (e) =>
    @activePage.onNewCrit(e)

  saveCurrentCrit: (e) =>
    @activePage.saveCurrentCrit(e)
    toggleOptions(false)
    ($ '#crit-comment').val('')

  removeCurrentCrit: (e) =>
    @activePage.removeCurrentCrit(e)
    toggleOptions(false)

  cancelCurrentCrit: (e) =>
    @activePage.cancelCurrentCrit(e)
    toggleOptions(false)

  removeAll: (e) =>
    @activePage.removeAll(e)
    @clearCrits 
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
    $.post('', newPageUrl: ($ 'form#new-page input[type=url]').val(), @onLoad)
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
    @pages[page._id] = new Page(this, page) for page in project.pages
    path = location.pathname.split('/')
    @base = path[1]
    @id = path[2]
    pageId = path[3] || @firstPageId()    
    pageId = project.pages[project.pages.length - 1]._id if @addingNewPage     
    ($ '#active-page + ul.dropdown-menu').html(PAGES_DROPDOWN(project: project))
    @showPage(pageId)
    removeLoader()
    @onReady(this)

window.Project = Project
