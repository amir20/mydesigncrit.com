app = angular.module('designcrit',
  ['designcritProjectService', 'designcritController', 'designcritRestService', 'designcritDirectives', 'ngRoute', 'ui.bootstrap'])

app.config ['$locationProvider', '$routeProvider', ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode(true)
  $routeProvider.when('/projects/:projectId/pages/:pageId', templateUrl: 'page.html', controller: 'PageCtrl')
]
