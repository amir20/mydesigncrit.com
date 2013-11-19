crit = ($document) ->
  restrict: "E"
  template: "<div class='crit' style='left: {{crit.x}}px; top:{{crit.y}}px; width: {{crit.width}}px; height: {{crit.height}}px'></div>"
  replace: true
  scope:
    crit: '='
  link: (scope, element, attrs) ->
    crit = scope.crit
    page = element.parent()

    if crit.create
      crit.width = 0
      crit.height = 0
      delete crit.create

      $document.bind 'mousemove', (e) ->
        crit.width = (e.pageX - page.offset().left) - crit.x
        crit.height = (e.pageY - page.offset().top) - crit.y
        scope.$apply()

      $document.bind 'mouseup', ->
        $document.unbind('mouseup')
        $document.unbind('mousemove')


app = angular.module('designcritDirectives', []).directive('crit', ['$document', crit])
