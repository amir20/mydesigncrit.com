express    = require 'express'
coffee     = require 'coffee-script'
mongoose   = require 'mongoose'
bootstrap  = require 'bootstrap-stylus'
stylus     = require 'stylus'

mongoose.connect('mongodb://localhost/reviewme')

app = module.exports = express.createServer()

app.configure ->
  app.set('views',  "#{__dirname}/views")
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
  app.use require('connect-assets')()


app.configure 'development', ->	
  app.set('view options', { pretty: true })
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

app.configure 'production', ->
  app.use(express.errorHandler())

require('./routes')(app)

app.listen(3000)

console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
