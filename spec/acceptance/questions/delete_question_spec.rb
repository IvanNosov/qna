require 'rails_helper'

feature 'Delete question', '
  In order to delete my own question
  As an Authenticated user
  I want to be able to delete my question
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user delete question' do
    sign_in user
    question

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Question was successfully destroyed'
    expect(current_path).to eq questions_path
  end

  scenario 'Not authenticated user tries delete question' do
    visit questions_path
    expect(page).to_not have_content 'Delete'
    expect(current_path).to eq questions_path
  end
end
