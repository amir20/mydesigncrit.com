class WelcomeController < ApplicationController
  before_action :verify_authenticity_token

  def index
  end
end
