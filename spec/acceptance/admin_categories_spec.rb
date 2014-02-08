require 'acceptance/acceptance_helper'

feature "Admin can manage categories", %q{
  In order to classify products
  As an admin
  I want to be able to manage categories
 } do

  let(:path) { admin_categories_path }
  let(:admin) { create(:admin) }      
    
  let!(:category) { create(:category) }
  let!(:sub_category) { create(:sub_category, parent: category) }
  let!(:new_category) { build(:new_category, parent: create(:main_category)) }
  

  it_behaves_like "Admin accessible"

  context "admin" do
    background do
      login admin      
    end

    scenario 'Admin views categories list' do
      visit path

      expect(page).to have_link 'Создать', href: new_admin_category_path

      expect(page).to have_content 'Категории'
      expect(page).to have_selector 'th', :text => 'Название'
      expect(page).to have_selector 'th', :text => 'Описание'
      expect(page).to have_selector 'th', :text => 'Родительская категория'
      expect(page).to have_selector 'th', :text => 'Изображение'
      
      expect_to_have_category(category)
      expect_to_have_category(sub_category)      

      expect(page).to have_link 'Изменить', href: edit_admin_category_path(category)
      expect(page).to have_link 'Удалить', href: admin_category_path(category)
    end

    scenario 'Admin creates new category' do
      visit new_admin_category_path

      expect(page).to have_content 'Новая категория'

      fill_in 'Название', with: new_category.name
      fill_in 'Описание', with: new_category.description      
      select new_category.parent.name, from: 'category[parent_id]'
      expect { click_on 'Сохранить' }.to change(Category, :count).by(1)

      expect_to_be_on_category_show_page new_category
      expect(page).to have_content 'Категория сохранена'
    end

    scenario 'Admin updates existing category' do
      visit edit_admin_category_path(category)

      expect(page).to have_content 'Редактирование категории'
      expect(page).to have_field 'Название', :with => category.name
      expect(page).to have_field 'Описание', :with => category.description      
      expect(page).to have_select 'category[parent_id]', :selected => []

      fill_in 'Название', with: new_category.name
      fill_in 'Описание', with: new_category.description      
      select new_category.parent.name, from: 'category[parent_id]'
      expect { click_on 'Сохранить' }.to change(Category, :count).by(0)
      
      expect_to_be_on_category_show_page new_category
      expect(page).to have_content 'Категория сохранена'
    end

    scenario 'Admin upload one image and associate it with existing category, then delete it' do
      # TODO: Looks like CarrierWave doesn't support russian file names, fix it
      # expect_to_upload_image 'spec/support/images/красивая картинка.jpg'
      expect_to_upload_image 'spec/support/images/another image.jpg'

      expect(page).to have_selector 'img', count: 1
      click_link 'Удалить', match: :first

      expect(page).to have_content 'Изображение удалено'
      expect(page).to have_selector 'img', count: 0
    end

    scenario 'Admin deletes existing category' do
      visit admin_category_path(sub_category)      
      
      expect(page).to have_content sub_category.name
      expect { click_on 'Удалить' }.to change(Category, :count).by(-1)

      expect(current_path).to match(admin_categories_path)
      expect(page).to_not have_content sub_category.name
    end

    def expect_to_have_category(category)
      within '.list' do
        expect(page).to have_content category.name
        expect(page).to have_content category.description      
        expect(page).to have_content category.parent.name if category.parent
        # to check img
      end
    end

    def expect_to_be_on_category_show_page(category)
      expect(current_path).to match(admin_category_path(id: '.+'))

      expect(page).to have_content 'Название'
      expect(page).to have_content 'Описание'      
      expect(page).to have_content 'Родительская категория' if category.parent
      expect(page).to have_content 'Изображение' if category.image

      expect(page).to have_content category.name
      expect(page).to have_content category.description
      expect(page).to have_content category.parent.name if category.parent
      # to check img
    end

    def expect_to_upload_image(image_path)
      visit admin_category_path(category)

      expect(page).to have_content 'Добавить изображение'
      attach_file 'Картинка', image_path
      click_on 'Загрузить изображение'

      expect(page).to have_content 'Изображение сохранено'
      expect(page).to have_xpath("//img[contains(@src, '#{File.basename(image_path).gsub(' ', '_')}')]")
    end
  end
end