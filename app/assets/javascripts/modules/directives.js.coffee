crit = ($document) ->
  restrict: 'E'
  templateUrl: 'crit.html'
  replace: true
  scope:
    crit: '='
    selectedCrit: '='
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
      scope.crit.width = 0
      scope.crit.height = 0
      $document.bind 'mousemove', resize
      $document.bind 'mouseup', mouseup

    scope.move = (e) =>
      if e.which is 1
        @startX = e.pageX - page.offset().left - scope.crit.x
        @startY = e.pageY - page.offset().top - scope.crit.y
        $document.bind 'mousemove', move
        $document.bind 'mouseup', mouseup
        scope.selectedCrit = scope.crit
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

    scope.delete = ->
      scope.crit.$delete()
      scope.$emit('crit.delete', scope.crit)


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

    spinner = new Spinner(opts).spin(element.find('#spinner')[0])

app = angular.module('designcritDirectives', [])
app.directive('crit', ['$document', crit])
app.directive('loader', [loader])
