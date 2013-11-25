class PageCtrl
  constructor: ($scope, $routeParams, JsonRestClient, ProjectService) ->
    $scope.data = ProjectService
    pageId = parseInt($routeParams.pageId)
    $scope.$on 'crit.delete', (e, crit) -> ProjectService.selectedPage.crits.splice(ProjectService.selectedPage.crits.indexOf(crit), 1)

    ProjectService.pages.$promise.then =>
      ProjectService.selectedPage = (page for page in ProjectService.pages when page.id is pageId)[0]
      ProjectService.selectedPage.crits = ProjectService.client.crit(pageId).query()
      ProjectService.selectedCrit = null

    $scope.createCrit = (e) ->
      if e.which is 1
        page = $('#page')
        Crit = ProjectService.client.crit(pageId)
        crit = new Crit(x: e.pageX - page.offset().left, y: e.pageY - page.offset().top)
        crit.$save()
        crit.create = true
        ProjectService.selectedCrit = crit
        ProjectService.selectedPage.crits.push(crit)


class ProjectCtrl
  constructor: ($scope, $timeout, JsonRestClient, ProjectService) ->
    $scope.data = ProjectService
    $scope.$watch 'projectId', ->
      ProjectService.client = JsonRestClient.client($scope.projectId)
      ProjectService.project = ProjectService.client.project()
      ProjectService.pages = ProjectService.client.pages()


    timeout = null
    $scope.saveSelectedCrit = (e) ->
      $timeout.cancel(timeout)
      timeout = $timeout (-> ProjectService.selectedCrit.$update()), 300


class HeaderCtrl
  constructor: ($scope, ProjectService) ->
    $scope.data = ProjectService


app = angular.module('designcritController', [])
app.controller('PageCtrl', ['$scope', '$routeParams', 'JsonRestClient', 'ProjectService', PageCtrl])
app.controller('ProjectCtrl', ['$scope', '$timeout', 'JsonRestClient', 'ProjectService', ProjectCtrl])
app.controller('HeaderCtrl', ['$scope', 'ProjectService', HeaderCtrl])
