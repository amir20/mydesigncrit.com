$ ->
  $('form#new-project-form').on submit: ->
    $(this).height(200).find('button.btn').attr(disabled: true)

  $('input[type=url]').on
    keypress: (e) ->
      if e.which == 46
        url = $(this).val()
        $(this).val("http://#{url}") if url.indexOf('http') != 0
    paste: ->
      setTimeout (=>
        url = $(this).val()
        $(this).val("http://#{url}") if url.indexOf('http') != 0
      ), 0
