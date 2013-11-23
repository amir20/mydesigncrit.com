class CritsController < ApplicationController
  before_action { @page = Project.find(params[:project_id]).pages.find(params[:page_id]) }

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
  end


  private
  def crit_params
    params.require(:crit).permit(:width, :height, :x, :y, :comment)
  end
end
