require 'rails_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user create the question' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask question'
    fill_in 'Title', with: 'Test'
    fill_in 'Body', with: 'test'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end
end
