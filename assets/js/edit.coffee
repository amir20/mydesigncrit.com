$ ->
  project = new Project(($ '#edit').data('project-id')) if notEmpty($ '#edit')
  $('.thumbs-down, .thumbs-up').on click: -> false
  $('#crit-comment').on keypress: (e) ->
    project.saveCurrentCrit() if e.which == 13 && (e.metaKey || e.ctrlKey)
