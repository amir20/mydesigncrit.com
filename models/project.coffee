mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

ProjectSchema = new Schema
    created_date: (type: Date, default: Date.now),
    url: String,
    screenshot: String,
    screenshotWidth: Number,
    screenshotHeight: Number

  
module.exports = mongoose.model 'Project', ProjectSchema
