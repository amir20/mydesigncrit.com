class ProjectsController < ApplicationController
  def index

  end

  def create
    @project = Project.create(title: 'Untitled')
    @page = @project.pages.create(url: params[:url])
    @page.process

    render :show
  end

  def update
  end

  def destroy

  end

  def show
    @project = Project.find(params[:id])
  end
end
