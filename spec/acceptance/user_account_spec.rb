require 'acceptance/acceptance_helper'

feature 'User login', %q{  
  As an user
  I want to login into auction
  In order to take part in auctions
 } do

  let(:user) { create(:user) }

  background do
    visit root_path
  end

  context 'for unregistered user' do
    scenario 'Unauthenticated user can login or create account' do
      expect(page).to have_content 'Текущие аукционы'
      expect(page).to have_link 'Вход'
      expect(page).to have_link 'Регистрация'
    end

    scenario 'User creates new account' do
      visit new_user_registration_path

      fill_in 'Email', with: 'user@mail.com'
      fill_in 'Пароль', with: 'secret'
      fill_in 'Подтверждение пароля', with: 'secret'
      fill_in 'Ник', with: 'nickname'
      click_on 'Зарегистрироваться'

      expect(current_path).to eq(root_path)
      expect(page).to have_link 'user@mail.com'
      expect(page).to have_link 'Выход'
    end

    scenario "can't see profile" do
      visit profile_path
      expect(current_path).to eq(new_user_session_path)
    end
  end

  context 'for registered user' do
    background do
      click_on 'Вход'
      sign_in_with user.email, user.password
    end

    scenario 'login' do
      expect(current_path).to eq(root_path)    
      expect(page).to have_link user.email
      expect(page).to have_link 'Выход'
      expect(page).to have_content 'Текущие аукционы'
      expect(page).to have_content 'Вход выполнен'    
    end

    scenario 'logout' do    
      click_on 'Выход'

      expect(page).to have_link 'Вход'
      expect(page).to have_content 'Выход выполнен'
    end

    scenario 'see profile' do
      auth = create(:authorization, user: user)
      visit profile_path

      expect(page).to have_content 'Профиль'
      expect(page).to have_content 'Email'
      expect(page).to have_content 'Ник'

      expect(page).to have_content user.email
      expect(page).to have_content user.nickname

      within '.authorizations' do
        expect(page).to have_content 'Соц. сеть'
        expect(page).to have_content 'ID'

        expect(page).to have_content auth.provider
        expect(page).to have_content auth.uid
      end
    end
  end

  context 'OAuth login' do
    context 'with full OAuth information' do
      scenario 'facebook' do
        visit new_user_session_path
        OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: 'test@mail.com', nickname: 'Nick' }})

        click_on 'Войти через Facebook'

        expect(current_path).to eq(root_path)
        expect(page).to have_content 'Вход в систему выполнен с учётной записью из Facebook'
      end
    end

    context 'without full OAuth information' do
      scenario 'vkontakte' do
        visit new_user_session_path
        OmniAuth.config.add_mock(:vkontakte, {uid: '12345', info: { } })

        click_on 'Войти через Vkontakte'

        expect(current_path).to eq(new_user_registration_path)
        expect(page).to have_content 'Пожалуйста, завершите регистрацию'
        fill_in 'Email', with: 'user@mail.com'
        fill_in 'Пароль', with: 'secret'
        fill_in 'Подтверждение пароля', with: 'secret'
        fill_in 'Ник', with: 'nickname'
        click_on 'Зарегистрироваться'

        expect(current_path).to eq(root_path)
        expect(page).to have_link 'user@mail.com'
        expect(page).to have_link 'Выход'
      end
    end
  end
end