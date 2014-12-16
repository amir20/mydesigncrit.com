require 'rails_helper'

describe ProjectsController do
  describe 'POST #create' do
    context 'with valid attributes' do
      before(:each) { allow_any_instance_of(Page).to receive(:process) }

      it 'create a new project' do
        expect do
          post :create, private: 'true', url: 'http://amirraminfar.com'
        end.to change(Project, :count).by(1)
      end

      it 'redirect to project/x/pages/y' do
        post :create, private: 'true', url: 'http://amirraminfar.com'
        expect(response).to redirect_to [assigns(:project), assigns(:project).pages.first]
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
end
