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
        saveWebShot job, -> res.redirect("/#{job.id}")
    else
      res.send('URL not defined')
            
  app.get '/:id', (req, res) ->
    Job.findById req.params.id,  (err, job) ->
      res.render('job', title: 'Preview', job: job)

saveWebShot = (job, callback) ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      console.log("Fetching [#{job.url}]")
      page.open job.url, (status) ->        
        console.log("Saving to file [#{job.id}.png]")
        page.render "public/phantom/#{job.id}.png", -> 
          callback()            
          ph.exit()