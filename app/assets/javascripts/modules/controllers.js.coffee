class PageCtrl
  constructor: ($scope, $routeParams, $timeout, JsonRestClient, ProjectService) ->
    $scope.data = ProjectService
    pageId = parseInt($routeParams.pageId)
    $scope.$on 'crit.delete', (e, crit) ->
      ProjectService.selectedCrit = null if ProjectService.selectedCrit == crit
      ProjectService.selectedPage.crits.splice(ProjectService.selectedPage.crits.indexOf(crit), 1)

    ProjectService.selectedCrit = null

    $scope.loading = true

    loaded = (pages) ->
      selectedPage = (page for page in pages when page.id is pageId)[0]
      if selectedPage.processed is true
        ProjectService.selectedPage = selectedPage
        ProjectService.pages = pages
        ProjectService.selectedPage.crits = ProjectService.client.crit(pageId).query()
        $scope.loading = false
      else
        $timeout (->
          ProjectService.client.pages().$promise.then loaded
        ), 2500

    ProjectService.pages.$promise.then loaded

    $scope.createCrit = (e) ->
      if e.which is 1
        $page = $('#page')
        Crit = ProjectService.client.crit(pageId)
        crit = new Crit(x: e.pageX - $page.offset().left - 15, y: e.pageY - $page.offset().top - 15, width: 0, height: 0)
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


class HeaderCtrl
  constructor: ($scope, $modal,  $location, ProjectService) ->
    $scope.data = ProjectService

    $scope.showModal = ->
      modalInstance = $modal.open
        templateUrl: 'newPageModal.html'
        controller: NewPageModalCtrl

      modalInstance.result.then (url) ->

        Page = ProjectService.client.page
        page = new Page(url: url)
        page.$save ->
          ProjectService.pages = ProjectService.client.pages()
          $location.path("/projects/#{ProjectService.project.id}/pages/#{page.id}")


class NewPageModalCtrl
  constructor: ($scope, $modalInstance) ->
    $scope.selected = { url: '' }

    $scope.cancel = ->
      $modalInstance.dismiss('cancel')

    $scope.add = ->
      $modalInstance.close($scope.selected.url)

class ShareCtrl
  constructor: ($scope, JsonRestClient) ->
    $scope.$watch 'shareId', ->
      $scope.project = JsonRestClient.share($scope.shareId)

app = angular.module('designcritController', [])
app.controller('PageCtrl', ['$scope', '$routeParams', '$timeout', 'JsonRestClient', 'ProjectService', PageCtrl])
app.controller('ProjectCtrl', ['$scope', '$timeout', 'JsonRestClient', 'ProjectService', ProjectCtrl])
app.controller('HeaderCtrl', ['$scope', '$modal', '$location', 'ProjectService', HeaderCtrl])
app.controller('NewPageModalCtrl', ['$scope', '$modalInstance', NewPageModalCtrl])
app.controller('ShareCtrl', ['$scope', 'JsonRestClient', ShareCtrl])
