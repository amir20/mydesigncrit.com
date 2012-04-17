everyauth = require 'everyauth'

module.exports = (app) ->
  app.get '/', (req, res) ->
    console.log everyauth.user
    console.log req.session.auth
    res.render('index', title: 'myDesignCrit.com [BETA]')

  require('./project')(app)
  
