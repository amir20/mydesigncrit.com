phantom = require 'phantom'

exports.capture = (url, id, callback) ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      page.set 'viewportSize', width: 1024, height: 700
      path = "public/phantom/#{id}.png"
      console.log("Opening [#{url}]")
      page.open url, (status) ->
        console.log("Rendering to file [#{path}]")
        page.evaluate (-> document.title), (title) ->
          page.render path, ->
            ph.exit()
            callback title, path
