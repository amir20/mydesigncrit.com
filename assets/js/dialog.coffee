activeDialog = null

spinnnerOpts =
  lines: 11 # The number of lines to draw
  length: 0 # The length of each line
  width: 4 # The line thickness
  radius: 10 # The radius of the inner circle
  corners: 1 # Corner roundness (0..1)
  rotate: 0 # The rotation offset
  color: "#000" # #rgb or #rrggbb
  speed: 1.6 # Rounds per second
  trail: 71 # Afterglow percentage
  shadow: false # Whether to render a shadow
  hwaccel: false # Whether to use hardware acceleration
  className: "spinner" # The CSS class to assign to the spinner
  zIndex: 2e9 # The z-index (defaults to 2000000000)
  top: "auto" # Top position relative to parent in px
  left: "auto" # Left position relative to parent in px

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
    @dialog.addClass('loading').find('.content').html('').load(e.target.action, $(e.target).serializeObject(), @onLoad)


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
    new Dialog(@href)