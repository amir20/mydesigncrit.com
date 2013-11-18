angular.module('designcritRestService', ['ngResource']).factory 'JsonRestClient', ['$resource', ($resource) ->
  Project = $resource('/projects/:id.json', id: '@id')
  project: Project
]
