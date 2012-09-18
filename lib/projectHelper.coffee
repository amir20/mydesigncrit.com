Project = require '../models/project'
gm = require 'gm'
screenshotHelper = require './screenshotHelper'

exports.createProject = (req, callback) ->
  project = new Project
    author: (if req.isLoggedIn then req.user.email else req.sessionID)     
    
  project.save (error) =>
    console.log "Created a new project with id [#{project.id}]."
    console.log error if error
    @addNewPage project, req.body.url, ->
      project.title = project.pages[0].title
      project.thumbnail = project.pages[0].thumbnail
      project.save -> callback(project)
        
exports.addNewPage = (project, url, callback) ->
  console.log "Created a new page for project [#{project.id}] with url [#{url}]."    
  screenshotHelper.capture url, "#{project.id}-#{Date.now()}", (title, path, thumbnail, size) ->
    page = 
      url: url
      screenshot: path
      title: title
      thumbnail: thumbnail
      screenshotWidth: size.width
      screenshotHeight: size.height      
    project.pages.push page  
    project.save (error) ->
      console.log error if error
      callback(project)

exports.findProjectsByUser = (user, start, limit, callback) ->
  if user? then Project.findByAuthor(user.email, callback, start, limit) else callback(null, [])

exports.isAuthorized = (req, project) ->
  !req.isProd || project.author is req.sessionID || (req.isLoggedIn && project.author is req.user.email)


