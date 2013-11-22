crit = ($document) ->
  restrict: "E"
  template: "<div class='crit' style='left: {{crit.x}}px; top:{{crit.y}}px; width: {{crit.width}}px; height: {{crit.height}}px'></div>"
  replace: true
  scope:
    crit: '='
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
      scope.$emit('save')

    move = (e) =>
      e.preventDefault()
      e.stopPropagation()
      scope.crit.x = e.pageX - page.offset().left - @startX
      scope.crit.y = e.pageY - page.offset().top - @startY
      scope.$apply()

    element.on 'mousedown', (e) =>
      e.preventDefault()
      e.stopPropagation()
      console.log scope.crit
      @startX = e.pageX - page.offset().left - scope.crit.x
      @startY = e.pageY - page.offset().top - scope.crit.y
      $document.bind 'mousemove', move
      $document.bind 'mouseup', mouseup

    if scope.crit.create
      scope.crit.width = 0
      scope.crit.height = 0
      delete scope.crit.create
      $document.bind 'mousemove', resize
      $document.bind 'mouseup', mouseup


app = angular.module('designcritDirectives', []).directive('crit', ['$document', crit])
