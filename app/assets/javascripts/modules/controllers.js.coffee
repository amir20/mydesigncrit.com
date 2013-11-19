class PageCtrl
  constructor: (@$scope, @$routeParams, @$document, @JsonService, @ProjectService) ->
    @$scope.data = ProjectService
    @$scope.createCrit = this.createCrit
    @page = $('#page')

    if ProjectService.project?
      @findPage(ProjectService.project)
    else
      ProjectService.project = JsonService.project.get(id: $routeParams.projectId, (project) => @findPage(project))


  findPage: (project) ->
    pageId = parseInt(@$routeParams.pageId)
    @ProjectService.selectedPage = (page for page in project.pages when page.id is pageId)[0]

  createCrit: (e) =>
    crit = {create: true}
    crit.x = e.pageX - @page.offset().left
    crit.y = e.pageY - @page.offset().top
    @ProjectService.selectedPage.crits.push(crit)


class ProjectCtrl
  constructor: ($scope, ProjectService) ->
    $scope.data = ProjectService


class HeaderCtrl
  constructor: ($scope, ProjectService) ->
    $scope.data = ProjectService


app = angular.module('designcritController', [])
app.controller('PageCtrl', ['$scope', '$routeParams', '$document', 'JsonRestClient', 'ProjectService', PageCtrl])
app.controller('HeaderCtrl', ['$scope', 'ProjectService', HeaderCtrl])
app.controller('ProjectCtrl', ['$scope', 'ProjectService', ProjectCtrl])
