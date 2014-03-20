require 'acceptance/acceptance_helper'

feature 'Admin can manage roles', %q{
  In order to grant permissions
  As an admin
  I want to be able to manage roles
 } do

  let(:path) { admin_roles_path }

  let!(:admin) { create(:admin, :with_avatar) }
  let(:roles) { Role.all }
  let(:admin_role) { Role.find_by name: 'admin' }
  let(:manager_role) { Role.find_by name: 'manager' }
  let(:permissions) { Permission.all }

  it_behaves_like 'Admin accessible'
  it_behaves_like 'Manager unaccessible'

  context 'admin' do
    before { login admin }

    scenario 'Admin views roles list' do
      visit path

      within '.page-header' do
        expect(page).to have_content 'Роли'
      end

      within '.list-header' do
        expect(page).to have_content 'Название'
      end

      roles.each do |role|
        within '.list-item', text: role.name do
          expect(page).to have_content role.name
          expect(page).to have_link 'Изменить', href: admin_role_permissions_path(role)
        end
      end
    end

    scenario 'Admin views particular role' do
      roles.each do |role|
        visit admin_role_path role

        within '.page-header' do
          expect(page).to have_content role.name
        end

        role.permissions.each do |permission|
          expect(page).to have_content permission.name
        end
      end
    end

    scenario 'Admin grants all permissions to manager' do
      visit admin_role_permissions_path(manager_role)

      expect(page).to have_content 'Настройка роли'
      expect(page).to have_content manager_role.name.downcase

      within '.permissions' do
        expect(page).to have_content 'Права'
        expect(page).to have_content 'Состояние'

        permissions.each do |permission|
          unless manager_role.permissions.include?(permission)
            within("##{permission.id}") { click_on 'Включить' }
          end
        end

        visit admin_role_path(manager_role)
        permissions.each { |permission| expect(page).to have_content permission.name }
      end
    end

    scenario 'Admin can not change admin role permissions' do
      visit admin_role_permissions_path(admin_role)

      expect(current_path).to eq path
      expect(page).to have_content 'Невозможно изменить права для администратора'
    end
  end
end