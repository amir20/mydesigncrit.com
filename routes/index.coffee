module.exports = (app) ->
  app.get '/', (req, res) -> res.render 'index', title: 'Welcome!', controller: 'welcome'
  require('./project')(app)
  require('./user')(app)
  require('./share')(app)
  
