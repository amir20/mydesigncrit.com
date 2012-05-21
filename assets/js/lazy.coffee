$ ->
  ($ "[data-lazy]").each ->
    $contiainer = $(this)
    modelUrl = $contiainer.data('lazy')
    templateUrl = "/templates/#{modelUrl.replace(/\//g, "-").replace(/^\-/, '').replace(/\.json$/, '')}.jade"
    ($ ($ this).data('lazy-trigger')).one click: ->
      $contiainer.text("loading...")
      $.get templateUrl, (template) ->
        compiledTemplate = jade.compile template
        $.getJSON modelUrl, (model) ->
          $contiainer.replaceWith compiledTemplate(model)



