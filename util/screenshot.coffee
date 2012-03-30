phantom = require 'phantom'

exports.capture = (url, id, callback) ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      console.log("Fetching [#{url}]")
      page.open url, (status) ->
        console.log("Saving to file [#{id}.png]")
        page.evaluate (-> document.body.clientHeight), (height) ->
          page.set 'viewportSize', width: 1024, height: height
          path = "public/phantom/#{id}.png"
          page.render path, ->
            ph.exit()
            callback path
