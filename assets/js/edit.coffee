$ ->
  if notEmpty($ '#edit')
    console.log 'Editting a new project'
    project = new Project(($ '#edit').data('project-id'))