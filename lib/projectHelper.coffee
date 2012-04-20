Project = require '../models/project'
gm = require 'gm'
screenshotHelper = require './screenshotHelper'
everyauthHelper = require './everyauthHelper'


exports.createProject = (req, callback) ->
  user = everyauthHelper.currentUser(req)
  project = new Project(url: req.body.url)
  project.author = if user? then user.email else req.sessionID
  project.save (error) ->
    console.log error if error
    console.log("Created project with id [#{project.id}] for [#{project.url}].")
    screenshotHelper.capture project.url, project.id, (path) ->
      project.screenshot = path.replace 'public', ''
      gm(path).size (err, size) ->
        console.log err if err
        project.screenshotWidth = size.width
        project.screenshotHeight = size.height
        project.save (error) ->
          console.log error if error
          callback(project)

exports.findProjectsByUser = (req, callback) ->
  user = everyauthHelper.currentUser(req)
  if user? then Project.findByAuthor(user.email, callback) else callback(null, [])
