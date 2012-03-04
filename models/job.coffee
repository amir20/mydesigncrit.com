mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

JobSchema = new Schema
    created_date: (type: Date, default: Date.now),
    url: String

JobSchema.methods.preview = (size = 'large') ->
  "/phantom/#{this.id}.png"
  
module.exports = mongoose.model 'Job', JobSchema
