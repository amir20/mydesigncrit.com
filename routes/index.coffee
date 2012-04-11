module.exports = (app) ->
  app.get '/', (req, res) -> res.render('index', title: 'Welcome to mydesigncrit.com')

  require('./project')(app)
  
