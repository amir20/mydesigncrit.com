class ProjectsController < ApplicationController
  def index
    @project = current_user.projects
  end

  def create
    @project = current_user.projects.create(title: 'Untitled')
    @page = @project.pages.create(url: params[:url], title: 'Loading...')
    @page.process

    redirect_to [@project, @page]
  end

  def update
    @project = current_user.projects.find(params[:id])
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy
  end

  def show
    @project = current_user.projects.find(params[:id])

    respond_to do |format|
      format.html { redirect_to [@project, @project.pages.first] unless request.xhr? }
      format.json
    end
  end

  def share
    @project = Project.find_by_share_id(params[:id])
  end
end
