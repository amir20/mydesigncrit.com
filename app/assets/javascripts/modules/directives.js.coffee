crit = ($document, $timeout, $rootScope) ->
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
    canEdit = scope.canEdit = -> !scope.crit.id || scope.crit.user.can_manage

    resize = (e) ->
      e.preventDefault()
      e.stopPropagation()
      scope.crit.width = (e.pageX - page.offset().left) - scope.crit.x
      scope.crit.height = (e.pageY - page.offset().top) - scope.crit.y
      scope.$apply()

    mouseup = (e) =>
      e.preventDefault()
      e.stopPropagation()
      unless scope.crit.id
        scope.selectedCrit = scope.crit
        $timeout (-> element.find('.comment-box textarea').focus()), 100
      scope.crit.$update() if scope.crit.id
      $document.unbind('mouseup')
      $document.unbind('mousemove')
      scope.$apply()

    move = (e) =>
      e.preventDefault()
      e.stopPropagation()
      scope.crit.x = e.pageX - page.offset().left - @startX
      scope.crit.y = e.pageY - page.offset().top - @startY
      scope.$apply()

    if scope.crit.create?
      $document.bind 'mousemove', resize
      $document.bind 'mouseup', mouseup

    scope.move = (e) =>
      if _.isEmpty $(e.target).parents('.handle')
        if e.which is 1 && canEdit()
          @startX = e.pageX - page.offset().left - scope.crit.x
          @startY = e.pageY - page.offset().top - scope.crit.y
          $document.bind 'mousemove', move
          $document.bind 'mouseup', mouseup
        e.stopPropagation()
        e.preventDefault()

    scope.resize = (e) ->
      if canEdit()
        $document.bind 'mousemove', resize
        $document.bind 'mouseup', mouseup
        scope.selectedCrit = scope.crit
      e.stopPropagation()
      e.preventDefault()

    scope.select = (e) ->
      if canEdit()
        scope.selectedCrit = scope.crit
        $timeout (-> element.find('.comment-box textarea').focus()), 100
      if _.isEmpty $(e.target).parents('.handle')
        e.stopPropagation()
        e.preventDefault()

    scope.highlight = (b) -> if b then element.addClass('selected') else element.removeClass('selected')

    scope.$watch 'selectedCrit', (selectedCrit, oldSelectedCrit) ->
      if selectedCrit != oldSelectedCrit
        $('html, body').animate(scrollTop: element.offset().top - 100, 400) if selectedCrit == scope.crit && !verge.inViewport(element)
        if !scope.crit.id && oldSelectedCrit == scope.crit
          if scope.crit.comment then scope.crit.$save() else $rootScope.$broadcast('crit.delete', scope.crit)

    commentWatcherEnabled = true
    timeout = null
    scope.disableCommentWatcher = -> commentWatcherEnabled = false
    scope.enableCommentWatcher = -> commentWatcherEnabled = true
    scope.$watch 'crit.comment', -> scope.comment = scope.crit.comment if commentWatcherEnabled
    scope.$watch 'comment', (newVal, oldVal) ->
      unless scope.crit.comment is newVal
        $timeout.cancel(timeout)
        scope.crit.comment = scope.comment
        timeout = $timeout (-> if !scope.crit.id then scope.crit.$save() else scope.crit.$update()), 1000


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

    scope.select = (crit) -> scope.selectedCrit = crit
    scope.showCrit = (crit) -> scope.hoveredCrit = crit
    scope.hideCrit = (crit) -> scope.hoveredCrit = null
    scope.$watch 'selectedCrit', (crit) -> scope.data.comment = crit.comment if crit
    scope.$watch 'selectedCrit.comment', (comment) -> scope.data.comment = comment

    timeout = null
    scope.$watch 'data.comment', (newVal, oldVal) ->
      unless !scope.selectedCrit? || scope.selectedCrit.comment is newVal
        $timeout.cancel(timeout)
        crit = scope.selectedCrit
        crit.comment = scope.data.comment
        timeout = $timeout (-> if !crit.id then crit.$save() else crit.$update()), 1000

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

loader = ->
  restrict: 'E'
  template: '<div id="loader" ng-show="loading"><div class="spinner"><div class="dot1"></div><div class="dot2"></div></div><div id="message">Please wait...</div></div>'
  replace: true
  scope:
    loading: '='
  link: (scope, element, attrs) ->

app = angular.module('designcritDirectives', [])
app.directive('crit', ['$document', '$timeout', '$rootScope', crit])
app.directive('sidebar', ['$timeout', sidebar])
app.directive('loader', [loader])
app.directive('deleteCrit', ['$rootScope', deleteCrit])
app.directive('input', ['$timeout', input])
app.directive('simpleElastic', ['$timeout', simpleElastic])
app.directive('a', [anchor])
