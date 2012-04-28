activeDialog = null

$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()
  $.each a, ->
    if o[@name] isnt `undefined`
      o[@name] = [ o[@name] ]  unless o[@name].push
      o[@name].push @value or ""
    else
      o[@name] = @value or ""

  return o

class Dialog
  constructor: (url) ->
    if activeDialog?
      activeDialog.load(url)
    else
      activeDialog = this
      $('<div />', id: 'overlay', click: @close).appendTo(document.body)
      @dialog = ($ '<div />', id: 'dialog')
      .append($('<div />', class: 'top-bar').append($('<a />', class: 'close', text: '×', click: @close)))
      .append($('<div />', class: 'content')).appendTo(document.body)
      @dialog.on 'click', 'a', (e) =>
        e.preventDefault()
        @load(e.target.href)
      @load(url)

  load: (url) =>
    @dialog.addClass('loading').find('.content').html('').load(url, @onLoad)

  handleForm: (e) =>
    e.preventDefault()
    @dialog.addClass('loading').find('.content').html('').load(e.target.action, $(e.target).serializeObject(), @onLoad)


  onLoad: =>
    @dialog.removeClass('loading')
    @dialog.find('[data-close]').one click: (e) =>
      e.preventDefault()
      @close()
    @dialog.find('form').on submit: @handleForm

  close: ->
    activeDialog = null
    ($ '#overlay, #dialog').remove()

jwerty.key 'esc', (e) ->
  e.preventDefault()
  activeDialog.close() if activeDialog?

$ ->
  ($ document.body).on 'click', 'a.dialog', (e) ->
    e.preventDefault()
    new Dialog(@href)