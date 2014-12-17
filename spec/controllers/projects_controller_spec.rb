require 'rails_helper'

describe ProjectsController do
  describe 'POST #create' do
    context 'with valid attributes' do
      before { allow_any_instance_of(Page).to receive(:process) }

      it 'create a new project' do
        expect do
          post :create, private: 'true', url: 'http://amirraminfar.com'
        end.to change(Project, :count).by(1)
      end

      it 'process a new page' do
        expect_any_instance_of(Page).to receive(:process)

        post :create, url: 'http://amirraminfar.com'
      end

      it 'calls create_from_url_or_image!' do
        expect(Page).to receive(:create_from_url_or_image!)

        post :create, url: 'http://amirraminfar.com'
      end

      it 'redirect to project/x/pages/y' do
        post :create, private: 'true', url: 'http://amirraminfar.com'
        expect(response).to redirect_to [assigns(:project), assigns(:project).pages.first]
      end

      it 'Project#punch is called' do
        expect_any_instance_of(Project).to receive(:punch)
        post :create, url: 'http://amirraminfar.com'
      end

      it 'create private project ' do
        post :create, private: 'true', url: 'http://amirraminfar.com'
        expect(assigns(:project)).to be_private
      end

      it 'default to public' do
        post :create, private: '', url: 'http://amirraminfar.com'
        expect(assigns(:project)).to_not be_private
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      let(:project) { Project.new(id: 1) }
      let(:user) { User.new(id: 1) }

      before do
        allow(Project).to receive(:find).with("#{project.id}").and_return(project)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'destroys project' do
        expect_to_authorize(:destroy, project)
        expect(project).to receive(:destroy)

        delete :destroy, id: project.id, user_id: user.id
      end

      it 'redirects to user page' do
        expect_to_authorize(:destroy, project)
        allow(project).to receive(:destroy)

        delete :destroy, id: project.id, user_id: user.id
        expect(response).to redirect_to user_projects_path(user)
      end
    end
  end
end
