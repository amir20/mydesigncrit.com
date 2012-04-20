everyauth = require 'everyauth'
sendResponse = (res, data) => res.redirect data.session.redirectPath || '/'

everyauth.google.appId('93758905889.apps.googleusercontent.com')
.myHostname('http://local.mydesigncrit.com:3000')
.appSecret('8fRgaU5vILLosexrImVp69RB')
.scope('https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email https://www.google.com/m8/feeds')
.findOrCreateUser((session, accessToken, accessTokenExtra, googleUserMetadata) ->
  return { email: googleUserMetadata.email, name: googleUserMetadata.name, picture: googleUserMetadata.picture }
).sendResponse sendResponse

everyauth.facebook.appId('335823783146542')
.myHostname('http://local.mydesigncrit.com:3000')
.appSecret('78c0fdaac09bce0b3defdf6e3f0d6cb5')
.scope('email')
.findOrCreateUser((session, accessToken, accessTokenExtra, fbUserMetadata) ->
  return { email: fbUserMetadata.email, name: fbUserMetadata.name, picture: fbUserMetadata.picture }
).sendResponse sendResponse

exports.configure = (app) ->
  everyauth.helpExpress app
  app.dynamicHelpers user: @currentUser
  app.get '/signin/:network', (req, res, next) =>
    req.session.redirectPath = req.header('Referer')
    res.redirect "/auth/#{req.params.network}"

exports.currentUser =  (req) ->
  return null if !req.session.auth?
  auth = req.session.auth
  return auth.google.user if auth.google?
  return auth.facebook.user if auth.facebook?

exports.loggedIn = (req) ->
  user = exports.currentUser(req)
  return user?