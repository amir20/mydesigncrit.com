mongoose = require 'mongoose'
ShortId = require 'shortid'
Schema = mongoose.Schema

Crit = new mongoose.Schema
  created_date: { type: Date, default: Date.now }
  comment: String
  x: Number
  y: Number
  width: Number
  height: Number

ProjectSchema = new Schema
    created_date: { type: Date, default: Date.now }
    url: { type: String, index: true }
    shortId: { type: String, index: true, default: ShortId.generate }
    author: { type: String, index: true }
    title: String
    screenshot: String
    screenshotWidth: Number
    screenshotHeight: Number
    crits: [Crit]

ProjectSchema.statics.findByAuthor = (author, cb) -> @find(author: author).desc('created_date').limit(40).run(cb)
ProjectSchema.statics.findByShortId = (id, cb) -> @findOne(shortId: id).run(cb)
  
module.exports = mongoose.model 'Project', ProjectSchema
