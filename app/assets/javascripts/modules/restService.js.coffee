angular.module('designcritRestService', ['ngResource']).factory 'JsonRestClient', ['$resource', ($resource) ->
  project: ->
    $resource('/projects/:id.json', {id: '@id'}, {update: {method: 'PATCH'}})

  page: (projectId) ->
    $resource('/projects/:projectId/pages/:id.json', {projectId: projectId, id: '@id'},
      { update: { method: 'PATCH' } })
]
