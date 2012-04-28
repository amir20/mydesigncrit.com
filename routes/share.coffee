Project = require '../models/project'
nodemailer = require 'nodemailer'
jade = require 'jade'

emailTemplate = jade.compile '''
!!! 5
html
  head
    title myDesignCrit.com - #{project.url}
    style(type='text/css')
      .message { padding: 10px; background: #eee; }
      .signature, .signature a { margin-top: 45px; color: #777; font-size: 90%}

  body
    h1 Hi there!
    p #{sender} has shared a design crit of #{project.url} with you.
    p
      a(href='http://mydesigncrit.com/v/#{project.shortId}') Click here
      |  to view this design crit.

    p #{sender} wrote:
      .message #{message}

    .signature
      a(href='http://mydesigncrit.com') mydesigncrit.com

'''
transport = nodemailer.createTransport 'smtp',
  service: "SendGrid"
  auth:
    {user: 'amirraminfar', pass: 'Snapple101'}

  module.exports = (app) ->
    app.get '/share/:id', (req, res) ->
      Project.findByShortId req.params.id, (err, project) ->
        res.render 'share/index', title: 'Share', project: project, controller: 'share', layout: !req.xhr

    app.post '/share/:id', (req, res) ->
      Project.findByShortId req.params.id, (err, project) ->
        options =
          from: '"My Design Crit" info@mydesigncrit.com'
          replyTo: req.body.from
          to: req.body.email
          subject: "mydesigncrit.com - #{project.url}!"
          html: emailTemplate(sender: req.body.sender, message: req.body.message, project: project)

        transport.sendMail options, (error, response) ->
          console.log err if err?

          res.render 'share/post',
            title: 'Share'
            project: project
            controller: 'share'
            err: err
            email: req.body.email
            layout: !req.xhr








