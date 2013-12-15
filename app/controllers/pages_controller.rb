class PagesController < ApplicationController
  before_action { @project = current_user.projects.find(params[:project_id]) }

  def index
    @pages = @project.pages
  end

  def create
    @page = Page.create_from_url_or_image!(params)
    @project.pages << @page

    respond_to do |format|
      format.html { redirect_to [@project, @page] }
      format.json { render action: 'show', status: :created, location: [@project, @page] }
    end
  end

  def update
    @page = @project.pages.find(params[:id])
  end

  def destroy
    @page = @project.pages.find(params[:id])
    @page.destroy
    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :no_content }
    end
  end

  def show
    @page = @project.pages.find(params[:id])
  end
end
