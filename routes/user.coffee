projectHelper = require '../lib/projectHelper'

module.exports = (app) ->
  app.get '/user/activity.:format?', (req, res) ->
    projectHelper.findProjectsByUser req, (err, projects) ->
      res.send activity: projects





