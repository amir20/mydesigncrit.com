$ ->
  $('form#new-project-form').on submit: ->
    $(this).height(200).find('button.btn').attr(disabled: true);