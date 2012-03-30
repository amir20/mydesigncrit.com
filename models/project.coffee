mongoose = require 'mongoose'
Schema = mongoose.Schema

Crit = new mongoose.Schema
  created_date: (type: Date, default: Date.now)
  message: String
  x: Number
  y: Number
  width: Number
  height: Number

ProjectSchema = new Schema
    created_date: (type: Date, default: Date.now)
    url: String
    screenshot: String
    screenshotWidth: Number
    screenshotHeight: Number
    crits: [Crit]
  
module.exports = mongoose.model 'Project', ProjectSchema
