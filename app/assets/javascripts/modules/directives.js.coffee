crit = ($document) ->
  restrict: 'E'
  templateUrl: 'crit.html'
  replace: true
  scope:
    crit: '='
    selectedCrit: '='
    hoveredCrit: '='
    index: '='
  link: (scope, element, attrs) ->
    page = element.parent()

    resize = (e) ->
      e.preventDefault()
      e.stopPropagation()
      scope.crit.width = (e.pageX - page.offset().left) - scope.crit.x
      scope.crit.height = (e.pageY - page.offset().top) - scope.crit.y
      scope.$apply()

    mouseup = (e) ->
      e.preventDefault()
      e.stopPropagation()
      $document.unbind('mouseup')
      $document.unbind('mousemove')
      scope.crit.$update()

    move = (e) =>
      e.preventDefault()
      e.stopPropagation()
      scope.crit.x = e.pageX - page.offset().left - @startX
      scope.crit.y = e.pageY - page.offset().top - @startY
      scope.$apply()

    if scope.crit.create
      delete scope.crit.create
      $document.bind 'mousemove', resize
      $document.bind 'mouseup', mouseup

    scope.move = (e) =>
      if e.which is 1
        @startX = e.pageX - page.offset().left - scope.crit.x
        @startY = e.pageY - page.offset().top - scope.crit.y
        $document.bind 'mousemove', move
        $document.bind 'mouseup', mouseup
        e.stopPropagation()
        e.preventDefault()

    scope.resize = (e) ->
      $document.bind 'mousemove', resize
      $document.bind 'mouseup', mouseup
      scope.selectedCrit = scope.crit
      e.stopPropagation()
      e.preventDefault()

    scope.select = (e) ->
      scope.selectedCrit = scope.crit
      e.stopPropagation()
      e.preventDefault()

    scope.highlight = (b) ->
      if b then element.addClass('selected') else element.removeClass('selected')


loader = ->
  restrict: 'E'
  template: '<div id="loader" ng-show="loading"><div id="message"><div id="spinner"></div><div>Please wait...</div></div></div>'
  replace: true
  scope:
    loading: '='
  link: (scope, element, attrs) ->
    opts =
      lines: 13 # The number of lines to draw
      length: 20 # The length of each line
      width: 10 # The line thickness
      radius: 30 # The radius of the inner circle
      corners: 1 # Corner roundness (0..1)
      rotate: 0 # The rotation offset
      direction: 1 # 1: clockwise, -1: counterclockwise
      color: "#fff" # #rgb or #rrggbb or array of colors
      speed: 1 # Rounds per second
      trail: 60 # Afterglow percentage
      shadow: false # Whether to render a shadow
      hwaccel: true # Whether to use hardware acceleration
      className: "spinner" # The CSS class to assign to the spinner
      zIndex: 2e9 # The z-index (defaults to 2000000000)
      top: "auto" # Top position relative to parent in px
      left: "auto" # Left position relative to parent in px

    spinner = new Spinner(opts).spin(document.getElementById('spinner'))


sidebar = ($timeout) ->
  restrict: 'E'
  templateUrl: 'sidebar.html'
  replace: true
  scope:
    crits: '='
    selectedCrit: '='
    hoveredCrit: '='

  link: (scope, element, attrs) ->
    scope.mac = !navigator.platform.indexOf("Mac")

    timeout = null
    scope.data = {comment: ''}

    scope.saveSelectedCrit = (e) ->
      $timeout.cancel(timeout)
      scope.saved = false
      crit = scope.selectedCrit
      crit.comment = scope.data.comment
      timeout = $timeout (->
        crit.$update()
        scope.saved = true
      ), 1000

    scope.done = ->
      scope.selectedCrit = null
      scope.hoveredCrit = null

    key '⌘ + enter, ctrl + enter', -> scope.$apply(-> scope.done())

    scope.select = (crit) ->
      scope.selectedCrit = crit

    scope.showCrit = (crit) ->
      scope.hoveredCrit = crit

    scope.hideCrit = (crit) ->
      scope.hoveredCrit = null

    scope.$watch 'selectedCrit', (crit) ->
      if crit
        $timeout(-> element.find('#comment').focus())
        scope.data.comment = crit.comment

deleteCrit = ($rootScope) ->
  restrict: 'A'
  scope:
    crit: '=deleteCrit'
  link: (scope, element, attrs) ->
    element.bind 'click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      scope.crit.$delete()
      $rootScope.$broadcast('crit.delete', scope.crit)

input = ($timeout) ->
  restrict: 'E'
  link: (scope, element, attrs) ->
    if(attrs.type == "url")
      element.bind 'keypress', (e) -> element.val("http://#{element.val()}") if e.which == 46 && element.val().indexOf('http') != 0
      element.bind 'paste', (e) ->
        $timeout (-> element.val("http://#{element.val()}") if element.val().indexOf('http') != 0), 100

app = angular.module('designcritDirectives', [])
app.directive('crit', ['$document', crit])
app.directive('sidebar', ['$timeout', sidebar])
app.directive('loader', [loader])
app.directive('deleteCrit', ['$rootScope', deleteCrit])
app.directive('input', ['$timeout', input])
