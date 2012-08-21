express = require 'express'
coffee = require 'coffee-script'
mongoose = require 'mongoose'
bootstrap = require 'bootstrap-stylus'
stylus = require 'stylus'
everyauth = require 'everyauth'
everyauthHelper = require './lib/everyauthHelper'
require './lib/date'

mongoose.connect 'mongodb://localhost/mydesigncrit'
everyauthHelper.initialize()

app = express()
app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()

  app.configure 'development', ->
    app.use express.session(secret: 'foo')

  app.configure 'production', ->
    RedisStore = require('connect-redis')(express)
    app.use express.session(secret: 'd13dc6fb75538e8f40112c407c5fe03a012b392', store: new RedisStore, cookie: { maxAge: 1209600000 })

  app.use everyauth.middleware()
  app.all '*', (req, res, next) ->
    req.user = everyauthHelper.currentUser(req)
    req.isLoggedIn = everyauthHelper.isLoggedIn(req)
    res.locals(isLoggedIn: req.isLoggedIn, user: req.user)
    next()

  app.use app.router
  app.use express.static(__dirname + '/public')
  app.use require('connect-assets')(minifyBuilds: false)
  app.locals(isProd : process.env.NODE_ENV is 'production', pretty : true)

  everyauthHelper.configure(app)

app.configure 'development', ->
  app.use express.errorHandler(dumpExceptions: true, showStack: true)

app.configure 'production', ->
  app.use express.errorHandler()

require('./routes')(app)

app.listen 3000

console.log("Express server listening on port %d in %s mode", 3000, app.settings.env)
