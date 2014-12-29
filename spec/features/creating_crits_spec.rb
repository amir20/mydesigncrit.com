require 'rails_helper'

feature 'Creating crits' do
  let!(:project) { create(:project_with_pages) }
  before do
    visit project_path(project)
  end

  scenario 'should create a crit for project', js: true do
    find('#page').click
    within :css, '.comment-box' do
      find('textarea').set('This is a test')
    end

    within :css, '#sidebar' do
      expect(page).to have_css('.btn.btn-warning')
    end

    expect(project.pages.first.crits.size).to be 1
  end
end
