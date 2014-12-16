require 'rails_helper'

feature 'Visiting welcome page' do
  scenario 'should have a guest user' do
    visit root_path
    expect(page).to have_content 'Hi, Guest'
  end

  scenario 'submitting a url should create one tab with page', js: true do
    visit root_path
    fill_in :url, with: 'http://amirraminfar.com'
    click_button 'Start'

    expect(page).to have_link('AmirRaminfar.com')
    expect(page).to have_css('#page[data-url="http://amirraminfar.com"]')
  end
end
