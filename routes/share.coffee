Project = require '../models/project'

module.exports = (app) ->
  app.get '/share/:id', (req, res) ->
    Project.findByShortId req.params.id, (err, project) ->
      res.render 'share/index', title: 'Share', project: project, controller: 'share', layout: !req.xhr





