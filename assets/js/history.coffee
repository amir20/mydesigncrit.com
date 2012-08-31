class History
  constructor: (@regex, @onPathChange) ->
    if history? && typeof history.pushState is "function"
      $(window).on popstate: (e) =>
        matches = location.pathname.match(@regex)
        @onPathChange(if matches? then matches[1] else '')
    else
      $(window).on hashchange: (e) =>
        matches = location.hash.substr(2).match(@regex)
        @onPathChange(if matches? then matches[1] else '')

  load: (path) ->
    if history? && typeof history.pushState is "function"
      history.pushState(null, null, path)
    else
      location.hash = "!#{path}"

  getHistoryPath: ->
    if history? && typeof history.pushState is "function"
      matches = location.pathname.match(@regex)
      if matches? then matches[1] else ''
    else
      matches = location.hash.substr(2).match(@regex)
      if matches? then matches[1] else ''

window.History = History
