class WelcomeController < ApplicationController
  before_action :verify_authenticity_token

  def index
    @projects = Project.accessible_by(current_ability).reorder(crits_count: :desc, updated_at: :desc).limit(8)
  end
end
