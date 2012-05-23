Project = require '../models/project'
nodemailer = require 'nodemailer'
jade = require 'jade'

emailTemplate = jade.compile '''
div(style='background: #F9F9FA; padding: 10px; border-radius: 4px;')
  h1 Hi there!
  p #{sender} has shared a project with you at mydesigncrit.com (<a href='http://mydesigncrit.com/v/#{project.shortId}'>#{project.title}</a>)
  p
    a(style='padding: 4px 10px; border-radius: 4px; color: #fff; border-color: #eee; background: #08c; display: inline-block;', href='http://mydesigncrit.com/v/#{project.shortId}') View This Project

  - if (message)
    p #{sender} wrote:
      .message(style='padding: 10px; background: #eee;') #{message}

  a(href='http://mydesigncrit.com', style='color: #777; font-size: 90%; display: inline-block; margin-top: 25px;') mydesigncrit team
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
          cc: req.body.from
          subject: "mydesigncrit.com - #{project.url}"
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








