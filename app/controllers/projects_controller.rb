class ProjectsController < ApplicationController
  def index
    @projects = if params[:user_id]
                  User.find(params[:user_id]).projects.accessible_by(current_ability)
                elsif current_user.present?
                  Project.accessible_by(current_ability).where('user_id != ?', current_user)
                else
                  Project.accessible_by(current_ability)
                end
  end

  def create
    create_guest_user_if_needed
    authorize! :create, Project

    @project = current_user.projects.create(title: 'Untitled', private: params[:private] == 'true')
    authorize! :create, @project => Page

    @page = Page.create_from_url_or_image!(params)
    @project.pages << @page

    @project.punch(request)

    respond_to do |format|
      format.html { redirect_to [@project, @page] }
      format.json { render action: 'show', status: :created, location: [@project, @page] }
    end
  end

  def update
    @project = Project.find(params[:id])
    authorize! :update, @project
  end

  def destroy
    @project = Project.find(params[:id])

    authorize! :destroy, @project

    @project.destroy

    redirect_to user_projects_path(current_user)
  end

  def show
    @project = Project.find(params[:id])
    authorize! :read, @project

    @project.punch(request) unless can? :manage, @project || !request.xhr?

    respond_to do |format|
      format.html { redirect_to [@project, @project.pages.first] unless request.xhr? }
      format.json
    end
  end

  def share
    @project = Project.find_by_share_id(params[:id])
    authorize! :share, @project
  end

  def email
    @project = Project.find_by_share_id(params[:id])
    authorize! :share, @project

    ShareMailer.send_project_to(@project, params[:to]).deliver

    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :no_content }
    end
  end
end
