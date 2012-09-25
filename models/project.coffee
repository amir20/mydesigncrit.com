mongoose = require 'mongoose'
ShortId = require 'shortid'
Schema = mongoose.Schema

Crit = new Schema
  created_date: { type: Date, default: Date.now }
  comment: String
  x: Number
  y: Number
  width: Number
  height: Number

Page = new Schema
  created_date: { type: Date, default: Date.now }
  comment: String
  url: { type: String, index: true }
  title: String
  screenshot: String
  thumbnail: String
  screenshotWidth: Number
  screenshotHeight: Number
  crits: [Crit]

ProjectSchema = new Schema
  created_date: { type: Date, default: Date.now }
  shortId: { type: String, index: true, default: ShortId.generate }
  author: { type: String, index: true }
  title: String
  thumbnail: String
  pages: [Page]

ProjectSchema.statics.findByAuthor = (author, cb, start = 0, limit = 10) -> @find(author: author).sort(created_date: 'desc').skip(start).limit(limit).exec(cb)
ProjectSchema.statics.findByShortId = (id, cb) -> @findOne(shortId: id).exec(cb)

module.exports = mongoose.model 'Project', ProjectSchema
