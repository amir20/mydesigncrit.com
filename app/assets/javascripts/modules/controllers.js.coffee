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
      $page = $('#page')
      if e.which is 1  && e.target is $page.get(0)
        Crit = ProjectService.client.crit(pageId)
        crit = new Crit(x: e.pageX - $page.offset().left - 15, y: e.pageY - $page.offset().top - 15, width: 0, height: 0)
        crit.create = true
        ProjectService.selectedPage.crits.push(crit)


class ProjectCtrl
  constructor: ($scope, $timeout, JsonRestClient, ProjectService, $location) ->
    $scope.data = ProjectService
    $scope.$watch 'projectId', ->
      ProjectService.client = JsonRestClient.client($scope.projectId)
      ProjectService.project = ProjectService.client.project()
      ProjectService.pages = ProjectService.client.pages()

    $scope.deletePage = (e, page) ->
      e.preventDefault()
      e.stopPropagation()
      page.$delete()

      index = ProjectService.pages.indexOf(page)
      ProjectService.pages.splice(index, 1)

      if(ProjectService.selectedPage == page)
        nextPage = ProjectService.pages[Math.max(0, index - 1)]
        $location.path("/projects/#{ProjectService.project.id}/pages/#{nextPage.id}")


class HeaderCtrl
  constructor: ($scope, $modal, $location, ProjectService) ->
    $scope.data = ProjectService

    $scope.newPageModal = ->
      modalInstance = $modal.open
        templateUrl: 'newPageModal.html'
        controller: 'NewPageModalCtrl'

      modalInstance.result.then (page) ->
        ProjectService.pages = ProjectService.client.pages()
        $location.path("/projects/#{ProjectService.project.id}/pages/#{page.id}")

    $scope.shareModal = ->
      modalInstance = $modal.open
        templateUrl: 'shareModal.html'
        controller: 'ShareModalCtrl'


class NewPageModalCtrl
  constructor: ($scope, $modalInstance, $upload, ProjectService) ->
    $scope.selected = { url: '' }

    $scope.cancel = ->
      $modalInstance.dismiss('cancel')

    $scope.add = ->
      Page = ProjectService.client.page
      page = new Page(url: $scope.selected.url)
      page.$save ->
        $modalInstance.close(page)

    $scope.onFileSelect = ($files) ->
      _.each $files, ($file) ->
        $scope.upload = $upload.upload(
          url: "/projects/#{ProjectService.project.id}/pages.json"
          file: $file
          fileFormDataName: 'image'
        ).then((response) ->
          $modalInstance.close(response.data)
        , null, (evt) ->
          $scope.progress =  parseInt(100.0 * evt.loaded / evt.total)
        )

class ShareModalCtrl
  constructor: ($scope, $modalInstance, $http, ProjectService) ->
    $scope.form = { to: '' }
    $scope.cancel = -> $modalInstance.dismiss('cancel')

    $scope.submitEmail = ->
      $scope.alert = 'Sending email...'
      $http.post("/v/#{ProjectService.project.share_id}", to: $scope.form.to).success ->
        $scope.form.to = ''
        $scope.alert = 'Email successfully sent.'


class ShareCtrl
  constructor: ($scope, JsonRestClient) ->
    $scope.$watch 'shareId', ->
      $scope.project = JsonRestClient.share($scope.shareId)


class WelcomeCtrl
  constructor: ($scope, $upload) ->
    $scope.onFileSelect = ($files) ->
      _.each $files, ($file) ->
        $scope.upload = $upload.upload(
          url: '/projects.json'
          file: $file
          data: { private: $('#privacy').is(':checked') }
          fileFormDataName: 'image'
        ).then((response) ->
          window.location = response.headers('Location')
        , null, (evt) ->
          $scope.progress =  parseInt(100.0 * evt.loaded / evt.total)
        )

class TitleCtrl
  constructor: ($scope, ProjectService) ->
    $scope.data = ProjectService

app = angular.module('designcritController', [])
app.controller('PageCtrl', ['$scope', '$routeParams', '$timeout', 'JsonRestClient', 'ProjectService', PageCtrl])
app.controller('ProjectCtrl', ['$scope', '$timeout', 'JsonRestClient', 'ProjectService', '$location', ProjectCtrl])
app.controller('HeaderCtrl', ['$scope', '$modal', '$location', 'ProjectService', HeaderCtrl])
app.controller('NewPageModalCtrl', ['$scope', '$modalInstance', '$upload', 'ProjectService', NewPageModalCtrl])
app.controller('ShareModalCtrl', ['$scope', '$modalInstance', '$http', 'ProjectService', ShareModalCtrl])
app.controller('ShareCtrl', ['$scope', 'JsonRestClient', ShareCtrl])
app.controller('WelcomeCtrl', ['$scope', '$upload', WelcomeCtrl])
app.controller('TitleCtrl', ['$scope', 'ProjectService', TitleCtrl])


