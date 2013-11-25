crit = ($document) ->
  restrict: 'E'
  templateUrl: 'crit.html'
  replace: true
  scope:
    crit: '='
    selectedCrit: '='
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


app = angular.module('designcritDirectives', [])
app.directive('crit', ['$document', crit])
