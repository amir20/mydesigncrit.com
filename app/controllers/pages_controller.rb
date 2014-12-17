class PagesController < ApplicationController
  before_action { @project = Project.find(params[:project_id]) }

  def index
    authorize! :read, @project

    @pages = @project.pages
  end

  def create
    authorize! :create, @project.pages.new
    @page = @project.pages.create_from_url_or_image!(params)

    respond_to do |format|
      format.html { redirect_to [@project, @page] }
      format.json { render action: 'show', status: :created, location: [@project, @page] }
    end
  end

  def destroy
    @page = @project.pages.find(params[:id])
    authorize! :destroy, @page

    @page.destroy
    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :no_content }
    end
  end

  def show
    @page = @project.pages.find(params[:id])

    authorize! :read, @project
    authorize! :read, @page
  end
end
