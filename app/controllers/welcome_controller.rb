class WelcomeController < ApplicationController
  before_action :verify_authenticity_token

  def index
    @projects = Project.accessible_by(current_ability).updated_since(1.week.ago).most_hit(2.week.ago, 8)
  end
end
