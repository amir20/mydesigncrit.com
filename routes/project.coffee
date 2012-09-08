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

  app.get '/edit/:projectId/:pageId?.:format?', (req, res) ->
    Project.findById req.params.projectId, (err, project) ->
      if project?
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
                res.render 'project/edit', title: '', project: project, controller: controller
            else
              res.render 'project/edit', title: '', project: project, controller: controller
          else
            res.redirect "/v/#{project.id}"
       else
         res.send 'Project not found', 404

  app.post '/edit/:projectId/:pageId', (req, res) ->
    Project.findById req.params.projectId, (err, project) ->
      if project? && projectHelper.isAuthorized(req, project)
        if req.body.newPageUrl?
          projectHelper.addNewPage project, req.body.newPageUrl, -> res.send project
        else        
          project.pages.id(req.params.pageId).crits = req.body.crits          
          project.save (error) -> res.send project
            

  app.get '/v/:projectId/:pageId?.:format?', (req, res) ->
    Project.findByShortId req.params.projectId, (err, project) ->
      if req.params.format is 'json'
        res.send project
      else
        res.render 'project/view', title: project.title, project: project, controller: controller, canEdit: projectHelper.isAuthorized(req, project)




