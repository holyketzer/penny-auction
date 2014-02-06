require 'acceptance/acceptance_helper'

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

  scenario "Unauthenticated user tries to get an access to admin area" do
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content 'Вам необходимо войти или зарегистрироваться'
  end

  scenario "Admin successfully logging into admin area" do
    sign_in_with admin.email, admin.password
    
    expect(current_path).to eq(admin_root_path)
    expect(page).to have_content 'Панель управления'
    expect(page).to have_link 'Категории', href: admin_categories_path, count: 2
    expect(page).to have_link 'Товары', href: admin_products_path, count: 2
  end

  scenario "Login with wrong credentials" do
    sign_in_with 'wrong@mail.com', 'wrong'

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content 'Неверное имя пользователя или пароль'
  end

  scenario "Non-admin user tries to log in" do      
    sign_in_with user.email, user.password

    expect(current_path).to_not eq(admin_root_path)
    expect(page).to have_content "У вас нет прав доступа к этой странице"
  end
end