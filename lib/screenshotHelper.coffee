phantom = require 'phantom'
gm = require 'gm'

exports.capture = (url, id, callback) ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      page.set 'viewportSize', width: 1024, height: 700
      path = "public/phantom/#{id}.png"
      lowResThumb = "public/phantom/#{id}_thumbnail.png"
      highResThumb = "public/phantom/#{id}_thumbnail-2x.png"
      console.log("Opening [#{url}]")
      page.open url, (status) ->
        console.log("Rendering to file [#{path}]")
        page.evaluate (-> document.title), (title) ->
          page.render path, ->
            ph.exit()
            gm(path).thumb 160, 120, lowResThumb, 80, ->
              gm(path).thumb 320, 240, highResThumb, 80, ->
                gm(path).size (err, size) ->
                  callback(title, path.replace('public', ''), lowResThumb.replace('public', ''), size)


