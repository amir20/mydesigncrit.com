activeDialog = null

spinnnerOpts =
  lines: 11
  length: 0
  width: 4 
  radius: 10
  corners: 1
  rotate: 0 
  color: "#000" 
  speed: 1.6
  trail: 71
  shadow: true 
  hwaccel: true
  className: "spinner"
  zIndex: 2e9
  top: "auto"
  left: "auto"

class Dialog
  constructor: (url) ->
    if activeDialog?
      activeDialog.load(url)
    else       
      $('<div />', id: 'overlay', click: @close).appendTo(document.body)
      @dialog = ($ '<div />', id: 'dialog')
        .append(($ '<div />', class: 'top-bar').append($ '<a />', class: 'close', text: '×', click: @close))
        .append(($ '<div />', class: 'content')).appendTo(document.body)
      @dialog.on 'click', 'a', (e) =>
        e.preventDefault()
        @load(e.target.href)
      @load(url)

  load: (url) =>
    @dialog.spin(spinnnerOpts).find('.content').html('').load(url, @onLoad)

  handleForm: (e) =>
    e.preventDefault()
    @dialog.spin(spinnnerOpts).find('.content').html('').load(e.target.action, $(e.target).serializeObject(), @onLoad)

  onLoad: =>
    @dialog.spin(false)
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
    activeDialog = new Dialog(@href)