require 'spec_helper'

feature 'User login', %q{  
  As an user
  I want to login into auction
  In order to take part in auctions
 } do

  let(:user) { create(:user) }

  background do
    visit root_path
  end

  scenario 'Unauthenticated user goes to index page' do
    expect(page).to have_content 'Текущие аукционы'
    expect(page).to have_link 'Вход'
    expect(page).to have_link 'Регистрация'
  end

  context 'Registered' do
    background do
      click_on 'Вход'
      sign_in_with user.email, user.password
    end

    scenario 'user login' do
      expect(current_path).to eq(root_path)    
      expect(page).to have_link user.email
      expect(page).to have_link 'Выход'
      expect(page).to have_content 'Текущие аукционы'
      expect(page).to have_content 'Вход выполнен'    
    end

    scenario 'user logout' do    
      click_on 'Выход'

      expect(page).to have_link 'Вход'
      expect(page).to have_content 'Выход выполнен'
    end
  end
end