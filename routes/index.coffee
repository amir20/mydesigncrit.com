phantom = require 'phantom'
Job = require '../models/job'

module.exports = (app) ->
  app.get '/', (req, res) -> res.render('index', title: 'Welcome' ) 
  
  app.post '/', (req, res) ->
    if req.body.url?.length      
      job = new Job(url: req.body.url)
      job.save (error) ->         
        throw error if error
        console.log("Created job id [#{job.id}] with [#{job.url}].")
        saveWebShot job, -> res.redirect("/#{job._id}")
    else
      res.send('URL not defined')
            
  app.get '/:id', (req, res) ->
    job = Job.findById req.params.id,  (err, doc) ->
      res.render('job', title: 'Preview', preview: "/phantom/#{doc.id}.png", job: doc)

saveWebShot = (job, callback) ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      console.log("Fetching [#{job.url}]")
      page.open job.url, (status) ->        
        console.log("Saving to file [#{job._id}.png]")
        page.render "public/phantom/#{job._id}.png", -> 
          callback()            
          ph.exit()