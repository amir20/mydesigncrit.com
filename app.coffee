express = require 'express'
coffee = require 'coffee-script'
mongoose = require 'mongoose'
bootstrap = require 'bootstrap-stylus'
stylus = require 'stylus'
everyauth = require 'everyauth'

mongoose.connect 'mongodb://localhost/mydesigncrit'

app = module.exports = express.createServer()
lastUser = null
everyauth.google.appId('93758905889.apps.googleusercontent.com')
.appSecret('8fRgaU5vILLosexrImVp69RB')
.scope('https://www.googleapis.com/auth/userinfo.email https://www.google.com/m8/feeds')
.findOrCreateUser((session, accessToken, accessTokenExtra, googleUserMetadata) ->
  promise = @Promise()
  promise.fulfill(googleUserMetadata)
  promise
).redirectPath('/')



app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view options', pretty: true
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session({secret: 'd3751038b3174d46971c7226d8959338'})
  app.use everyauth.middleware()
  app.use app.router
  app.use express.static(__dirname + '/public')
  app.use require('connect-assets')(minifyBuilds: false)
  everyauth.helpExpress app
  app.dynamicHelpers user: (req, res) -> req.session.auth
  app.dynamicHelpers isProd: (req, res) -> process.env.NODE_ENV == 'production'

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

require('./routes')(app)

app.listen 3000

console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
