class CritsController < ApplicationController
  before_action { @page = Project.find(params[:project_id]).pages.find(params[:page_id]) }

  def index
    authorize! :read, @page
    @crits = @page.crits
  end

  def create
    create_guest_user_if_needed
    authorize! :create, @page.crits.new

    @crit = @page.crits.build(crit_params)
    @crit.user = current_user
    @crit.save!
  end

  def update
    @crit = @page.crits.find(params[:id])
    authorize! :update, @crit

    @crit.update(crit_params)
  end

  def destroy
    @crit = @page.crits.find(params[:id])
    authorize! :destroy, @crit

    @crit.destroy

    head :no_content
  end


  private
  def crit_params
    params.require(:crit).permit(:width, :height, :x, :y, :comment)
  end
end
