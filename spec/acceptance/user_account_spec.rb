require 'acceptance/acceptance_helper'
require 'webmock/rspec'

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
      expect(page).to have_content 'Аукционы'
      expect(page).to have_link 'Вход'
      expect(page).to have_link 'Регистрация'
    end

    scenario 'User creates new account' do
      visit new_user_registration_path

      fill_in 'Email', with: 'user@mail.com'
      fill_in 'Пароль', with: 'secret'
      fill_in 'Подтверждение пароля', with: 'secret'
      fill_in 'Ник', with: 'nickname'
      attach_file 'Аватар', 'spec/support/images/tiger.jpg'
      click_on 'Зарегистрироваться'

      expect(current_path).to eq(root_path)
      expect(page).to have_link 'user@mail.com'
      expect(page).to have_link 'Выход'

      visit profile_path
      within '.avatar' do
        expect(image_src).to_not be_empty
      end
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
      expect(page).to have_content 'Аукционы'
      expect(page).to have_content 'Вход выполнен'
    end

    scenario 'logout' do
      click_on 'Выход'

      expect(page).to have_link 'Вход'
      expect(page).to have_content 'Выход выполнен'
    end

    describe 'profile' do
      let!(:auth) { nil }
      let!(:avatar) { create(:avatar, user: user) }
      before { visit profile_path }

      scenario 'change avatar' do
        within('.page-header') { click_on 'Изменить' }

        expect(current_path).to eq(profile_edit_path)
        old_avatar_path = nil
        within '.avatar' do
          old_avatar_path = image_src
          expect(old_avatar_path).to_not be_empty

          attach_file 'Аватар', 'spec/support/images/another image.jpg'
        end

        expect { click_on 'Сохранить' }.to change(Avatar, :count).by(0)

        expect(current_path).to eq(profile_path)
        expect(page).to have_content 'Ваша учётная запись изменена'
        within('.avatar') { expect(image_src).to_not eq(old_avatar_path) }
      end

      scenario 'change nickname' do
        within('.page-header') { click_on 'Изменить' }

        avatar_path = within('.avatar') { image_src }
        fill_in 'Ник', with: 'NewNickname'
        click_on 'Сохранить'

        expect(current_path).to eq(profile_path)
        expect(page).to have_content 'Ваша учётная запись изменена'
        expect(page).to have_content 'NewNickname'
        within('.avatar') { expect(image_src).to eq(avatar_path) }
      end

      context 'with Facebook authorization' do
        let!(:auth) { create(:authorization, user: user, provider: 'facebook') }

        scenario 'see details' do
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

        scenario 'user can associate account' do
          within '.associate-account' do
            expect(page).to have_link 'Привязать к Vkontakte'
            expect(page).to_not have_link 'Привязать к Facebook'
          end
        end
      end

      context 'with Vkontakte authorization' do
        let!(:auth) { create(:authorization, user: user, provider: 'vkontakte') }

        scenario 'user can associate account' do
          within '.associate-account' do
            expect(page).to_not have_link 'Привязать к Vkontakte'
            expect(page).to have_link 'Привязать к Facebook'
          end
        end
      end
    end
  end

  describe 'OAuth registration' do
    before do
      stub_request(:get, 'www.imagehost.test/avatar.jpg').to_return(:body => File.new('spec/support/images/another image.jpg'), :status => 200)
    end

    context 'with full user information' do
      scenario 'facebook' do
        visit new_user_session_path
        OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: 'test@mail.com', nickname: 'Nick', image: 'http://www.imagehost.test/avatar.jpg' }})

        click_on 'Войти через Facebook'

        expect(current_path).to eq(root_path)
        expect(page).to have_content 'Вход в систему выполнен с учётной записью из Facebook'

        visit profile_path
        within '.avatar' do
          expect(image_src).to_not be_empty
        end
      end
    end

    context 'without full user information' do
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
        click_on 'Выход'

        visit new_user_session_path
        click_on 'Войти через Vkontakte'
        expect(page).to have_content 'Вход в систему выполнен с учётной записью из Vkontakte'
      end

      scenario 'facebook' do
        OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: 'test@mail.com', image: 'http://www.imagehost.test/avatar.jpg' }})

        expect_successeful_facebok_login
      end
    end

    context 'with http to https avatar url redirect' do
      let(:avatar_url) { 'http://www.imagehost.com/avatar.jpg' }
      let(:redirection_url) { 'https://cdn.imagehost.com/avatar.jpg' }

      before do
        stub_request(:get, avatar_url).to_return(status: 302, headers: { 'Location' => redirection_url, 'Content-Type' => 'image/jpeg' })
        stub_request(:get, redirection_url).to_return(body: File.new('spec/support/images/another image.jpg'), status: 200)
      end

      scenario 'facebook' do
        OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: 'test@mail.com', image: avatar_url }})

        expect_successeful_facebok_login
      end
    end
  end

  describe 'OAuth association' do
    context 'signed up with Facebook' do
      let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
      let!(:vk_auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '789400') }
      before do
        OmniAuth.config.add_mock(vk_auth.provider, {uid: vk_auth.uid, info: { } })
        user.create_authorization(auth)
        login(user)
        visit profile_path
      end

      scenario 'user add Vkontake account' do
        click_on 'Привязать к Vkontakte'

        expect(current_path).to eq(profile_path)
        expect(page).to have_content 'Ваш профиль привязан к аккаунту Vkontakte'
        expect(page).to_not have_link 'Привязать к Vkontakte'
      end

      context 'Vkontakte profile assigned with another user' do
        let!(:vk_user) { create(:user) }
        before { vk_user.create_authorization(vk_auth) }

        scenario 'user can not add Vkontakte profile' do
          click_on 'Привязать к Vkontakte'

          expect(current_path).to eq(profile_path)
          expect(page).to have_content 'Этот аккаунт Vkontakte уже связан с другим профилем'
          expect(page).to have_link 'Привязать к Vkontakte'
        end
      end
    end
  end

  private

  def expect_successeful_facebok_login
    visit new_user_session_path
    click_on 'Войти через Facebook'

    expect(current_path).to eq(new_user_registration_path)
    expect(page).to have_content 'Пожалуйста, завершите регистрацию'
    expect(find_field('Email').value).to eq('test@mail.com')

    fill_in 'Пароль', with: 'secret'
    fill_in 'Подтверждение пароля', with: 'secret'
    fill_in 'Ник', with: 'nickname'
    click_on 'Зарегистрироваться'

    expect(current_path).to eq(root_path)
    expect(page).to have_link 'test@mail.com'
    expect(page).to have_link 'Выход'

    visit profile_path
    within '.avatar' do
      expect(image_src).to_not be_empty
    end
  end
end