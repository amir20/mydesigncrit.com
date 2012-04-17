module.exports = (app) ->
  app.get '/', (req, res) -> res.render('index', title: 'myDesignCrit.com [BETA]')

  require('./project')(app)
  
