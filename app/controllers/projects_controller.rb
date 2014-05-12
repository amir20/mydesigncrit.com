class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def create
    create_guest_user_if_needed
    @project = current_user.projects.create(title: 'Untitled')
    @page = Page.create_from_url_or_image!(params)
    @project.pages << @page


    respond_to do |format|
      format.html { redirect_to [@project, @page] }
      format.json { render action: 'show', status: :created, location: [@project, @page] }
    end
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

  def email
    @project = Project.find_by_share_id(params[:id])
    ShareMailer.send_project_to(@project , params[:to]).deliver

    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :no_content }
    end
  end
end
