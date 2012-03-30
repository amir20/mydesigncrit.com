Project = require '../models/project'
gm = require 'gm'
screenshot = require '../util/screenshot'

module.exports = (app) ->
  app.post '/(index.:format)?', (req, res) ->
    if req.body.url?.length
      if req.body.url.indexOf('http') != 0
        req.body.url = 'http://' + req.body.url

      project = new Project(url: req.body.url)
      project.save (error) ->
        throw error if error
        console.log("Created project with id [#{project.id}] for [#{project.url}].")
        screenshot.capture project.url, project.id, (path) ->
          project.screenshot = path.replace 'public', ''
          gm(path).size (err, size) ->
            project.screenshotWidth = size.width
            project.screenshotHeight = size.height
            project.save (error) ->
              throw error if error
              if req.params.format is 'json' then res.send project else res.redirect "/edit/#{project.id}"
    else
      res.send('URL not defined')

  app.get '/edit/:id.:format?', (req, res) ->
    Project.findById req.params.id, (err, project) ->
      if req.params.format is 'json'
        res.send project
      else
        res.render('project/edit', title: 'Preview', project: project)

  app.post '/edit/:id', (req, res) ->
    Project.findById req.params.id, (err, project) ->
      project.crits = req.body.crits if req.body.crits?
      project.save ->
        res.send project

