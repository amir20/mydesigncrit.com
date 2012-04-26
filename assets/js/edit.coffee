$ ->
  if ($ '#edit').exists()
    project = new Project(($ '#edit').data('project-id'))
    $('.thumbs-down, .thumbs-up').on click: -> false
    $('#crit-comment').on keypress: (e) -> project.saveCurrentCrit() if e.which == 13 && (e.metaKey || e.ctrlKey)
    $(document).on keypress: (e) -> project.cancelCurrentCrit() if e.keyCode == 27
