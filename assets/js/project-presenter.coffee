class ProjectPresenter
  constructor: (@project) ->
    for crit in @project.crits
      crit.container.find('.comment').append(crit.comment.replace(/\r|\n/g, "<br/>")) if crit.comment?

window.ProjectPresenter = ProjectPresenter
