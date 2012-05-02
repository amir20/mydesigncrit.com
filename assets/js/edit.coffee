$ ->
  if ($ '#edit, #view').exists()
    project = new Project(($ '#view').exists(), (project) ->
      new ProjectPresenter(project) if ($ '#view').exists()
    )
    $('.thumbs-down, .thumbs-up').on click: -> false

    jwerty.key '⌃+↩/⌘+↩', (-> project.saveCurrentCrit()), '#crit-comment'
    jwerty.key 'esc', -> project.cancelCurrentCrit()
