class PageCtrl
  constructor: ($scope, $routeParams, $document, JsonRestClient, @ProjectService) ->
    $scope.data = ProjectService
    $scope.createCrit = @createCrit
    @page = $('#page')
    pageId = parseInt($routeParams.pageId)
    unless ProjectService.project?
      ProjectService.project = JsonRestClient.project().get(id: $routeParams.projectId) unless ProjectService.project?
      ProjectService.pages = JsonRestClient.page($routeParams.projectId).query ->
        ProjectService.selectedPage = (page for page in ProjectService.pages when page.id is pageId)[0]

    ProjectService.selectedPage = (page for page in ProjectService.pages when page.id is pageId)[0]

    $scope.$on 'save', (event, params) -> ProjectService.selectedPage.$update()

  createCrit: (e) =>
    crit = {create: true}
    crit.x = e.pageX - @page.offset().left
    crit.y = e.pageY - @page.offset().top
    @ProjectService.selectedPage.crits.push(crit)


class ProjectCtrl
  constructor: ($scope, JsonRestClient, ProjectService) ->
    $scope.data = ProjectService


class HeaderCtrl
  constructor: ($scope, ProjectService) ->
    $scope.data = ProjectService


app = angular.module('designcritController', [])
app.controller('PageCtrl', ['$scope', '$routeParams', '$document', 'JsonRestClient', 'ProjectService', PageCtrl])
app.controller('ProjectCtrl', ['$scope', 'JsonRestClient', 'ProjectService', ProjectCtrl])
app.controller('HeaderCtrl', ['$scope', 'ProjectService', HeaderCtrl])
