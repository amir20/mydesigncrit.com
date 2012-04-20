$ ->
  $("[data-lazy]").each ->
    $contiainer = $(this)
    modelUrl = $contiainer.data('lazy')
    templateUrl = "/templates/#{modelUrl.replace(/\//g, "-").replace(/^\-/, '')}.jade"
    $($(this).data('lazy-trigger')).one click: ->
      $.get templateUrl, (template) ->
        compiledTemplate = jade.compile template
        $.getJSON modelUrl, (model) ->
          $contiainer.replaceWith compiledTemplate(model)



