class ProjectsController < ApplicationController
  def index

  end

  def create
    @project = Project.create(name: 'Untitled')
    page = Page.create(url: params[:url])
    @project.pages << page
    @project.save
    page.process


  end

  def update
  end

  def destroy

  end
end
