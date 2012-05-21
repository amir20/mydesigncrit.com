phantom = require 'phantom'
gm = require 'gm'

exports.capture = (url, id, callback) ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      page.set 'viewportSize', width: 1024, height: 700
      path = "public/phantom/#{id}.png"
      thumbnail = "public/phantom/#{id}_thumbnail.png"
      console.log("Opening [#{url}]")
      page.open url, (status) ->
        console.log("Rendering to file [#{path}]")
        page.evaluate (-> document.title), (title) ->
          page.render path, ->
            ph.exit()
            gm(path).thumb 160, 120, thumbnail, 80, ->
              gm(path).size (err, size) ->
                callback title, path.replace('public', ''), thumbnail.replace('public', ''), size


