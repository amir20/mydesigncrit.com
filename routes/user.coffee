projectHelper = require '../lib/projectHelper'


module.exports = (app) ->
  app.get '/user/activity/:type.:format?', (req, res) ->
    limit = if req.params.type is 'recent' then 15 else 100
    projectHelper.findProjectsByUser req.user, 0, limit, (err, projects) ->
      if req.params.format is 'json'
        res.send activity: projects
      else
        res.render 'user/activity',
          controller: 'user'
          projects: projects
          title: 'My Projects'





