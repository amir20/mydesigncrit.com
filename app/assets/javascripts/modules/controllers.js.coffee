class PageCtrl
  constructor: ($scope, $routeParams, JsonService) ->
    $scope.project = JsonService.project.get(id: $routeParams.projectId, (project) ->
      pageId = parseInt($routeParams.pageId)
      $scope.currentPage = (page for page in project.pages when page.id is pageId)[0]
    )

app = angular.module('designcritController', [])
app.controller('PageCtrl', ['$scope', '$routeParams', 'JsonRestClient', PageCtrl])
