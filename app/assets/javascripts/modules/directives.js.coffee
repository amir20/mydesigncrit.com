crit = ($document) ->
  restrict: "E"
  template: "<div class='crit' style='left: {{crit.x}}px; top:{{crit.y}}px; width: {{crit.width}}px; height: {{crit.height}}px'></div>"
  replace: true
  scope:
    crit: '='
  link: (scope, element, attrs) ->
    crit = scope.crit
    page = element.parent()

    resize = (e) ->
      e.preventDefault()
      e.stopPropagation()
      crit.width = (e.pageX - page.offset().left) - crit.x
      crit.height = (e.pageY - page.offset().top) - crit.y
      scope.$apply()

    mouseup = (e) ->
      e.preventDefault()
      e.stopPropagation()
      $document.unbind('mouseup')
      $document.unbind('mousemove')

    move = (e) =>
      e.preventDefault()
      e.stopPropagation()
      crit.x = e.pageX - page.offset().left - @startX
      crit.y = e.pageY - page.offset().top - @startY
      scope.$apply()

    element.on 'mousedown', (e) =>
      e.preventDefault()
      e.stopPropagation()
      @startX = e.pageX - page.offset().left - crit.x
      @startY = e.pageY - page.offset().top - crit.y
      $document.bind 'mousemove', move
      $document.bind 'mouseup', mouseup

    if crit.create
      crit.width = 0
      crit.height = 0
      delete crit.create
      $document.bind 'mousemove', resize
      $document.bind 'mouseup', mouseup


app = angular.module('designcritDirectives', []).directive('crit', ['$document', crit])
