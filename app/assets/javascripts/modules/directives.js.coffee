crit = ($document, $timeout) ->
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
    scope.comment = scope.crit.comment

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
      if _.isEmpty $(e.target).parents('.handle')
        if e.which is 1 && scope.crit.user.can_manage
          @startX = e.pageX - page.offset().left - scope.crit.x
          @startY = e.pageY - page.offset().top - scope.crit.y
          $document.bind 'mousemove', move
          $document.bind 'mouseup', mouseup
        e.stopPropagation()
        e.preventDefault()

    scope.resize = (e) ->
      if scope.crit.user.can_manage
        $document.bind 'mousemove', resize
        $document.bind 'mouseup', mouseup
        scope.selectedCrit = scope.crit
      e.stopPropagation()
      e.preventDefault()

    scope.select = (e) ->
      if _.isEmpty $(e.target).parents('.handle')
        scope.selectedCrit = scope.crit if scope.crit.user.can_manage
        e.stopPropagation()
        e.preventDefault()

    scope.highlight = (b) ->
      if b then element.addClass('selected') else element.removeClass('selected')

    scope.$watch 'selectedCrit', (selectedCrit) ->
      if selectedCrit == scope.crit
        $('html, body').animate(
          scrollTop: element.offset().top - 100
        , 500) if !verge.inViewport(element)

    timeout = null
    scope.$watch 'comment', (newVal, oldVal) ->
      unless newVal is oldVal
        $timeout.cancel(timeout)
        scope.crit.comment = scope.comment
        timeout = $timeout (-> scope.crit.$update()), 1000

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
    scope.data = comment: ''

    scope.done = ->
      scope.selectedCrit = null
      scope.hoveredCrit = null

    key '⌘ + enter, ctrl + enter', -> scope.$apply(-> scope.done())

    scope.select = (crit) -> scope.selectedCrit = crit
    scope.showCrit = (crit) -> scope.hoveredCrit = crit
    scope.hideCrit = (crit) -> scope.hoveredCrit = null
    scope.$watch 'selectedCrit', (crit) -> scope.data.comment = crit.comment if crit
    scope.$watch 'selectedCrit.comment', (comment) -> scope.data.comment = comment

    timeout = null
    scope.$watch 'data.comment', (newVal, oldVal) ->
      unless newVal is oldVal
        $timeout.cancel(timeout)
        scope.selectedCrit.comment = scope.data.comment
        timeout = $timeout (-> scope.selectedCrit.$update()), 1000

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
    if(attrs.type == 'url')
      element.bind 'keypress', (e) -> element.val("http://#{element.val()}") if e.which == 46 && element.val().indexOf('http') != 0
      element.bind 'paste', -> $timeout (-> element.val("http://#{element.val()}") if element.val().indexOf('http') != 0), 100

# Hack to fix routing when ng-route is not being used
anchor =  ->
  restrict: 'E'
  link: (scope, element, attrs) ->
    unless element.hasClass('routed')
      element.attr('target', '_self')

simpleElastic =  ($timeout) ->
  restrict: 'AC'
  require: 'ngModel'
  link: (scope, element, attrs, ngModel) ->
    scope.$watch (-> ngModel.$modelValue), (newValue) ->
      $timeout ->
        element.css('height', 'auto' )
        element.height(element.get(0).scrollHeight)


app = angular.module('designcritDirectives', [])
app.directive('crit', ['$document', '$timeout', crit])
app.directive('sidebar', ['$timeout', sidebar])
app.directive('loader', [loader])
app.directive('deleteCrit', ['$rootScope', deleteCrit])
app.directive('input', ['$timeout', input])
app.directive('simpleElastic', ['$timeout', simpleElastic])
app.directive('a', [anchor])
