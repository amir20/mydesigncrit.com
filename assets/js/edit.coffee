$ ->
  if ($ '#edit, #view').exists()
    project = new Project(($ '#edit, #view').data('project-id'), ($ '#view').exists(), (project) ->
      new ProjectPresenter(project) if ($ '#view').exists()
    )

    $('.thumbs-down, .thumbs-up').on click: -> false
    $('#crit-comment').on keypress: (e) -> project.saveCurrentCrit() if e.which == 13 && (e.metaKey || e.ctrlKey)
    $(document).on keypress: (e) -> project.cancelCurrentCrit() if e.keyCode == 27
