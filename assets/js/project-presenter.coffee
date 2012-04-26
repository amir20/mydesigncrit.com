class ProjectPresenter
  constructor: (@project) ->
    for crit in @project.crits
      crit.container.find('.comment').append(crit.comment)

window.ProjectPresenter = ProjectPresenter
