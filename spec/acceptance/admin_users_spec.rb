require 'acceptance/acceptance_helper'

feature 'Admin can manage users', %q{
  In order to appoint managers and bots
  As an admin
  I want to be able to manage users
 } do

  let(:path) { admin_users_path }

  let!(:admin) { create(:admin, :with_avatar) }
  let!(:manager) { create(:manager, :with_avatar) }
  let!(:user) { create(:user, :with_avatar) }
  let(:users) { [admin, manager, user] }

  it_behaves_like 'Admin accessible'
  it_behaves_like 'Manager unaccessible'

  context 'admin' do
    before { login admin }

    scenario 'Admin views users list' do
      visit path

      within '.page-header' do
        expect(page).to have_content 'Пользователи'
      end

      within '.list-header' do
        expect(page).to have_content 'Аватар'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Ник'
        expect(page).to have_content 'Роль'
      end

      users.each do |dude|
        within '.list-item', text: dude.email do
          expect(image_src).to eq(dude.avatar.small_thumb_url)
          expect(page).to have_content dude.email
          expect(page).to have_content dude.nickname
          expect(page).to have_content dude.role.name
          expect(page).to have_link 'Изменить', href: edit_admin_user_path(dude)
        end
      end
    end

    scenario 'Admin views particular user' do
      users.each do |dude|
        visit admin_user_path dude

        expect_user_view_page dude
      end
    end

    scenario 'Admin grant manager role to user' do
      visit edit_admin_user_path(user)

      expect(page).to have_content 'Редактирование прав пользователя'
      expect(page).to have_content user.email
      expect(page).to have_content user.nickname
      select 'manager', from: 'Роль'
      click_on 'Сохранить'

      expect(current_path).to eq admin_user_path(user)
      expect(page).to have_content 'manager'
    end

    scenario 'Admin can not change his own role' do
      visit edit_admin_user_path(admin)

      expect(current_path).to eq admin_users_path
      expect(page).to have_content 'Вы не можете изменить свою роль'
    end

    scenario 'Admin create a new bot' do
      visit path
      click_on 'Добавить бота'

      expect(page).to have_content 'Создание бота'

      bot = build(:bot)
      fill_in 'Email', with: bot.email
      fill_in 'Ник', with: bot.nickname
      expect { click_on 'Сохранить' }.to change(User, :count).by(1)

      expect(current_path).to match admin_user_path(id: '.+')
      expect_user_view_page bot
    end

    def expect_user_view_page(dude)
      within '.page-header' do
        expect(page).to have_content dude.nickname
      end

      expect(image_src).to eq(dude.avatar.thumb_url) if dude.avatar
      expect(page).to have_content dude.email
      expect(page).to have_content dude.role.name
    end
  end
end