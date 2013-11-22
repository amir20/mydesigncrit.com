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

    crits = {}
    @page.crits.map { |c| crits[c.id] = c }

    params['crits'].each do |crit|
      if crit['id']
        id = crit.delete('id').to_i
        crits[id].update(crit)
      else
        @page.crits.create(crit)
      end
    end
  end

  def destroy
    @page = @project.pages.find(params[:id])
    @page.delete
  end

  def show
    @page = @project.pages.find(params[:id])
  end
end
