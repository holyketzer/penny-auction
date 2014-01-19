require 'spec_helper'

feature "Admin panel", %q{
  In order to manage auction's settings
  As an admin
  I want to logging into admin area
 } do

  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  background do
    visit admin_root_path
  end

  context 'Admin' do
    scenario "Unauthenticated user tries to get an access to admin area" do
      expect(current_path).to eq(new_user_session_path)
      page.should have_content 'Вам необходимо войти или зарегистрироваться'
    end

    scenario "Admin successfully logging into admin area" do
      sign_in_with admin.email, admin.password
      page.should have_content 'Панель управления'
    end

    scenario "Login with wrong credentials" do
      sign_in_with 'wrong', 'wrong'

      current_path.should == new_user_session_path
      page.should have_content 'Неверное имя пользователя или пароль'
    end
  end

  context 'User' do
    scenario "Non-admin user tries to log in" do      
      sign_in_with user.email, user.password

      page.should have_content "У вас нет прав доступа к этой странице"
    end
  end
end