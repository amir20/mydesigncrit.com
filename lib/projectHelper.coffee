Project = require '../models/project'
gm = require 'gm'
screenshotHelper = require './screenshotHelper'

exports.createProject = (req, callback) ->
  project = new Project(url: req.body.url)
  project.author = if req.isLoggedIn then req.user.email else req.sessionID
  project.save (error) ->
    console.log error if error
    console.log("Created project with id [#{project.id}] for [#{project.url}].")
    screenshotHelper.capture project.url, project.id, (title, path, thumbnail, size) ->
      project.screenshot = path
      project.title = title
      project.thumbnail = thumbnail
      project.screenshotWidth = size.width
      project.screenshotHeight = size.height
      project.save (error) ->
        console.log error if error
        callback(project)

exports.findProjectsByUser = (user, start, limit, callback) ->
  if user? then Project.findByAuthor(user.email, callback, start, limit) else callback(null, [])

exports.isAuthorized = (req, project) ->
  project.author is req.sessionID || (req.isLoggedIn && project.author is req.user.email) || !req.isProd


