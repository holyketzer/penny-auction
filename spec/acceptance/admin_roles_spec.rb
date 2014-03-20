require 'acceptance/acceptance_helper'

feature 'Admin can manage roles', %q{
  In order to grant permissions
  As an admin
  I want to be able to manage roles
 } do

  let(:path) { admin_roles_path }

  let!(:admin) { create(:admin, :with_avatar) }
  let(:roles) { Role.all }

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
          expect(page).to have_link 'Изменить', href: edit_admin_role_path(role)
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
  end
end