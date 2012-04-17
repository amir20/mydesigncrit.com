mongoose = require 'mongoose'
Schema = mongoose.Schema

Crit = new mongoose.Schema
  created_date: (type: Date, default: Date.now)
  comment: String
  x: Number
  y: Number
  width: Number
  height: Number

ProjectSchema = new Schema
    created_date: { type: Date, default: Date.now }
    url: { type: String, index: true }
    author: { type: String, index: true }
    screenshot: String
    screenshotWidth: Number
    screenshotHeight: Number
    crits: [Crit]
  
module.exports = mongoose.model 'Project', ProjectSchema
