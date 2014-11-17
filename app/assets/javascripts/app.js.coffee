app = angular.module('designcrit',
  ['designcritProjectService',
   'designcritController',
   'designcritRestService',
   'designcritDirectives',
   'ngRoute',
   'ngClipboard',
   'ui.bootstrap',
   'angularMoment',
   'angularFileUpload'])

app.config ['$locationProvider', '$routeProvider', 'ngClipProvider', ($locationProvider, $routeProvider, ngClipProvider) ->
  $locationProvider.html5Mode(true)
  $routeProvider.when('/projects/:projectId/pages/:pageId', templateUrl: 'page.html', controller: 'PageCtrl')
]
