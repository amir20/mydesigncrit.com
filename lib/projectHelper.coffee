Project = require '../models/project'
gm = require 'gm'
screenshotHelper = require './screenshotHelper'

exports.createProject = (req, callback) ->
  page = url: req.body.url
  project = new Project
    author: (if req.isLoggedIn then req.user.email else req.sessionID)
    pages: [ page ]

  project.save (error) ->
    console.log error if error
    console.log("Created a new project with id [#{project.id}] for [#{page.url}].")
    page = project.pages[0]
    screenshotHelper.capture page.url, page.id, (title, path, thumbnail, size) ->
      page.screenshot = path
      page.title = title
      page.thumbnail = thumbnail
      page.screenshotWidth = size.width
      page.screenshotHeight = size.height
      project.save (error) ->
        console.log error if error
        callback(project)

exports.findProjectsByUser = (user, start, limit, callback) ->
  if user? then Project.findByAuthor(user.email, callback, start, limit) else callback(null, [])

exports.isAuthorized = (req, project) ->
  !req.isProd || project.author is req.sessionID || (req.isLoggedIn && project.author is req.user.email)


