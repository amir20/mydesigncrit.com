class PagesController < ApplicationController
  before_action { @project = Project.find(params[:project_id]) }

  def index
    @pages = @project.pages
  end

  def create
    @page = @project.pages.create(url: params[:url])
    @page.process
  end

  def update
    @page = @project.pages.find(params[:id])
  end

  def destroy
    @page = @project.pages.find(params[:id])
    @page.destroy
  end

  def show
    @page = @project.pages.find(params[:id])
  end
end
