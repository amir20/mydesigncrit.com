module.exports = (app) ->
  app.get '/', (req, res) -> res.render('index', title: 'Welcome!')
  require('./project')(app)
  require('./user')(app)
  
