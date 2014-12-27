require File.expand_path('../config/application', __FILE__)
DesigncritIo::Application.load_tasks


unless Rails.env.production?
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = %w(app spec)
  end

  RSpec::Core::RakeTask.new(:spec)

  task default: [:rubocop, :spec]
end
