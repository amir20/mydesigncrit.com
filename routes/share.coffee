Project = require '../models/project'
mailer = require('mailer')

module.exports = (app) ->
  app.get '/share/:id', (req, res) ->
    Project.findByShortId req.params.id, (err, project) ->
      res.render 'share/index', title: 'Share', project: project, controller: 'share', layout: !req.xhr

  app.post '/share/:id', (req, res) ->
    Project.findByShortId req.params.id, (err, project) ->
      mailer.send
        host: "smtp.sendgrid.net"
        port: "587"
        domain: "smtp.sendgrid.net"
        authentication: "login"
        username: 'amirraminfar'
        password: 'Snapple101'
        from: req.body.from
        to: req.body.email
        subject: "node_mailer test email"
        body: "hello this a test email from the node_mailer"
        (err, result) ->
          console.log err if err?
          res.render 'share/post', title: 'Share', project: project, controller: 'share', layout: !req.xhr






