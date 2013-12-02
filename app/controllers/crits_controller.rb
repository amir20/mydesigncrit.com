class CritsController < ApplicationController
  before_action { @page = current_user.projects.find(params[:project_id]).pages.find(params[:page_id]) }

  def index
    @crits = @page.crits
  end

  def create
    @crit = @page.crits.create(crit_params)
  end

  def update
    @crit = @page.crits.find(params[:id])
    @crit.update(crit_params)
  end

  def destroy
    @crit = @page.crits.find(params[:id])
    @crit.destroy

    head :no_content
  end


  private
  def crit_params
    params.require(:crit).permit(:width, :height, :x, :y, :comment)
  end
end
