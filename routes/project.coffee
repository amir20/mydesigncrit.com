phantom = require 'phantom'
Project = require '../models/project'
gm = require('gm')

module.exports = (app) ->
  app.post '/(index.:format)?', (req, res) ->    
    if req.body.url?.length      
      project = new Project(url: req.body.url)
      project.save (error) ->         
        throw error if error
        console.log("Created project id [#{project.id}] with [#{project.url}].")
        saveWebShot project, (path) -> 
          project.screenshot = path.replace 'public', ''
          gm(path).size (err, size) ->                                  
            project.screenshotWidth = size.width
            project.screenshotHeight = size.height                        
            project.save (error) ->
              throw error if error
              if req.params.format is 'json' then res.send project else res.redirect "/edit/#{project.id}"
    else
      res.send('URL not defined')
            
  app.get '/edit/:id', (req, res) ->
    Project.findById req.params.id,  (err, project) ->
      res.render('project/edit', title: 'Preview', project: project)
                
saveWebShot = (project, callback) ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      console.log("Fetching [#{project.url}]")
      page.open project.url, (status) ->        
        console.log("Saving to file [#{project.id}.png]")
        page.evaluate (-> document.body.clientHeight), (height) ->
          page.set 'viewportSize', width:1024, height:height
          path = "public/phantom/#{project.id}.png"        
          page.render path, -> 
            ph.exit() 
            callback path
       