Project = require '../models/project'
gm = require 'gm'
screenshotHelper = require '../lib/screenshot'
everyauthHelper = require '../lib/everyauth'

module.exports = (app) ->
  app.post '/(index.:format)?', (req, res) ->
    if req.body.url?.length
      if req.body.url.indexOf('http') != 0
        req.body.url = 'http://' + req.body.url

      user = everyauthHelper.currentUser(req)

      project = new Project(url: req.body.url)
      project.author = if user? then user.email else req.sessionID
      project.save (error) ->
        throw error if error
        console.log("Created project with id [#{project.id}] for [#{project.url}].")
        screenshotHelper.capture project.url, project.id, (path) ->
          project.screenshot = path.replace 'public', ''
          gm(path).size (err, size) ->
            console.log err if err
            project.screenshotWidth = size.width
            project.screenshotHeight = size.height
            project.save (error) ->
              console.log error if error
              if req.params.format is 'json' then res.send project else res.redirect "/edit/#{project.id}"
    else
      res.send('URL not defined')

  app.get '/edit/:id.:format?', (req, res) ->
    Project.findById req.params.id, (err, project) ->
      if req.params.format is 'json'
        res.send project
      else
        user = everyauthHelper.currentUser(req)
        if project.author is req.sessionID ||  (user? && project.author is user.email)
          if project.author is req.sessionID && user?
            project.author = user.email
            project.save ->
              res.render 'project/edit', title: "myDesignCrit.com - #{project.url}", project: project
          else
            res.render 'project/edit', title: "myDesignCrit.com - #{project.url}", project: project
        else
          res.render 'error/notAuthorized', title: "myDesignCrit.com - Not Authorized", status: 401


  app.post '/edit/:id', (req, res) ->
    Project.findById req.params.id, (err, project) ->
      project.crits = req.body.crits if req.body.crits?
      project.save ->
        res.send project

