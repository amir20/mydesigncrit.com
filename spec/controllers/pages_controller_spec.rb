require 'rails_helper'

describe PagesController do
  describe 'POST #create' do
    context 'with valid attributes' do
      let(:project) { Project.new(id: 1) }

      before do
        allow(Project).to receive(:find).and_return(project)
        allow_any_instance_of(Page).to receive(:process)
      end

      it 'calls create_from_url_or_image!' do
        expect_to_authorize(:create, instance_of(Page))
        expect(Page).to receive(:create_from_url_or_image!)
        post :create, project_id: project.id, url: 'http://amirraminfar.com'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      let(:project) { Project.new(id: 1) }
      let(:page) { Page.new(id: 1) }

      before do
        allow(Project).to receive(:find).with("#{project.id}").and_return(project)
        allow(project).to receive_message_chain(:pages, :find).and_return(page)
      end

      it 'destroys page' do
        expect_to_authorize(:destroy, page)
        expect(page).to receive(:destroy)

        delete :destroy, project_id: project.id, id: page.id
      end
    end
  end
end
