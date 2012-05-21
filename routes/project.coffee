Project = require '../models/project'
projectHelper = require '../lib/projectHelper'

controller = 'project'

module.exports = (app) ->
  app.post '/(index.:format)?', (req, res) ->
    if req.body.url?.length
      req.body.url = 'http://' + req.body.url if req.body.url.indexOf('http') != 0
      projectHelper.createProject req, (project) ->
        if req.params.format is 'json' then res.send project else res.redirect "/edit/#{project.id}"
    else
      res.send 'URL not defined'

  app.get '/edit/:id.:format?', (req, res) ->
    Project.findById req.params.id, (err, project) ->
      if req.params.format is 'json'
        if projectHelper.isAuthorized(req, project)
          res.send project
        else
          res.send 'Not Authorized', 401
      else
        if projectHelper.isAuthorized(req, project)
          if project.author is req.sessionID && req.isLoggedIn
            project.author = req.user.email
            project.save ->
              res.render 'project/edit', title: project.title, project: project, controller: controller
          else
            res.render 'project/edit', title: project.title, project: project, controller: controller
        else
          res.render 'error/notAuthorized', title: 'Not Authorized', status: 401, controller: controller

  app.get '/v/:id.:format?', (req, res) ->
    Project.findByShortId req.params.id, (err, project) ->
      if req.params.format is 'json'
        res.send project
      else
        res.render 'project/view', title: project.url, project: project, controller: controller, canEdit: projectHelper.isAuthorized(req, project)

  app.post '/edit/:id', (req, res) ->
    Project.findById req.params.id, (err, project) ->
      if projectHelper.isAuthorized(req, project)
        project.crits = req.body.crits
        project.save ->
          res.send project


