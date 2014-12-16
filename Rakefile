require File.expand_path('../config/application', __FILE__)
require 'rubocop/rake_task'

DesigncritIo::Application.load_tasks

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = %w(app spec)
end

unless Rails.env.production?
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: [:rubocop, :spec]
end
