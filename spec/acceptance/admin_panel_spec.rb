require 'acceptance/acceptance_helper'

feature 'Admin panel', %q{
  In order to manage auction's settings
  As an admin
  I want to logging into admin area
 } do

  context 'guest' do
    scenario 'Unauthenticated user tries to get an access to admin area' do
      visit admin_root_path
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content 'Вам необходимо войти или зарегистрироваться'
    end

    scenario 'Login with wrong credentials' do
      visit new_user_session_path
      sign_in_with 'wrong@mail.com', 'wrong'

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content 'Неверное имя пользователя или пароль'
    end
  end

  context 'admin' do
    let(:admin) { create(:admin) }
    before { login admin }

    it_behaves_like 'Auction manager'

    scenario 'Admin see additional buttons' do
      visit admin_root_path

      expect(page).to have_link 'На сайт', href: root_path
      expect(page).to have_link 'Пользователи', href: admin_users_path, count: 2
    end
  end

  context 'user' do
    let(:user) { create(:user) }
    before { login user }

    scenario 'Non-admin user tries to log in' do
      visit admin_root_path

      expect(current_path).to eq(root_path)
      expect(page).to have_content 'У вас нет прав доступа к этой странице'
    end
  end
end