mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

job_schema = new Schema
    created_date: (type: Date, default: Date.now),
    url: String

module.exports = mongoose.model 'Job', job_schema
