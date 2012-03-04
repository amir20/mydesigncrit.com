mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

ProjectSchema = new Schema
    created_date: (type: Date, default: Date.now),
    url: String,
    width: Number,
    height: Number

ProjectSchema.methods.preview = (size = 'large') ->
  "/phantom/#{this.id}.png"
  
module.exports = mongoose.model 'Project', ProjectSchema
