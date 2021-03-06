angular.module('designcritRestService', ['ngResource']).factory 'JsonRestClient', ['$resource', ($resource) ->
  share: (id) -> $resource('/v/:id.json', { id: id }).get()

  client: (projectId) ->
    project = $resource('/projects/:id.json', { id: projectId}, { update: { method: 'PATCH' } })
    page = $resource('/projects/:projectId/pages/:id.json', { projectId: projectId, id: '@id'}, { update: { method: 'PATCH' } } )

    project: -> project.get()
    page: page
    pages: -> page.query()
    crit: (pageId) ->
      $resource('/projects/:projectId/pages/:pageId/crits/:id.json', {projectId: projectId, pageId: pageId, id: '@id'}, { update: { method: 'PATCH' } })
]
