class ProjectPresenter
  constructor: (@project) ->
    for crit in @project.activePage.crits
      crit.container.find('.comment').text(crit.comment.replace(/\r|\n/g, "<br/>")) if crit.comment?

window.ProjectPresenter = ProjectPresenter
