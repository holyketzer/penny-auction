require 'spec_helper'

feature "Admin can manage products", %q{
  In order to sell the products
  As an admin
  I want to be able to manage products
 } do

  let(:path) { admin_products_path }
  let(:admin) { create(:admin) }  
    
  let!(:product) { create(:product) }
  let!(:new_product) { build(:new_product) }
  let!(:category) { product.category }
  let!(:new_category) { new_product.category }

  it_behaves_like "Admin accessible"

  context "admin" do
    background do
      visit new_user_session_path
      sign_in_with admin.email, admin.password
    end

    def expect_product_show_page(product)
      expect(current_path).to match(admin_product_path(id: '.+'))

      expect(page).to have_content 'Название'
      expect(page).to have_content 'Описание'
      expect(page).to have_content 'Цена'
      expect(page).to have_content 'Категория'

      expect(page).to have_content product.name
      expect(page).to have_content product.description
      expect(page).to have_content product.shop_price
      expect(page).to have_content product.category.name      
    end

    def expect_to_upload_image(image_path)
      visit admin_product_path(product)

      expect(page).to have_content 'Добавить изображение'
      attach_file 'Картинка', image_path
      click_on 'Загрузить изображение'

      expect(page).to have_content 'Изобажение сохранено'
      expect(page).to have_xpath("//img[contains(@src, '#{File.basename(image_path).gsub(' ', '_')}')]")
    end

    scenario 'Admin views products list' do
      visit path

      expect(page).to have_link 'Создать', href: new_admin_product_path

      expect(page).to have_content 'Список товаров'
      expect(page).to have_selector 'th', :text => 'Название'
      expect(page).to have_selector 'th', :text => 'Описание'
      expect(page).to have_selector 'th', :text => 'Цена'
      expect(page).to have_selector 'th', :text => 'Категория'
      
      expect(page).to have_selector 'td', :text => product.name
      expect(page).to have_selector 'td', :text => product.description
      expect(page).to have_selector 'td', :text => product.shop_price
      expect(page).to have_selector 'td', :text => product.category.name

      expect(page).to have_link 'Изменить', href: edit_admin_product_path(product)
      expect(page).to have_link 'Удалить', href: admin_product_path(product)
    end

    scenario 'Admin creates new product' do
      visit new_admin_product_path

      expect(page).to have_content 'Новый товар'

      fill_in 'Название', with: new_product.name
      fill_in 'Описание', with: new_product.description
      fill_in 'Цена', with: new_product.shop_price
      select new_product.category.name, from: 'product[category_id]'
      click_on 'Сохранить'

      expect_product_show_page new_product
      expect(page).to have_content 'Товар сохранён'
    end

    scenario 'Admin updates existing product' do
      visit edit_admin_product_path(product)

      expect(page).to have_content 'Редактирование товара'
      expect(page).to have_field 'Название', :with => product.name
      expect(page).to have_field 'Описание', :with => product.description
      expect(page).to have_field 'Цена', :with => product.shop_price
      expect(page).to have_select 'product[category_id]', :selected => product.category.name

      fill_in 'Название', with: new_product.name
      fill_in 'Описание', with: new_product.description
      fill_in 'Цена', with: new_product.shop_price
      select new_product.category.name, from: 'product[category_id]'
      click_on 'Сохранить'      
      
      expect_product_show_page new_product
      expect(page).to have_content 'Товар сохранён'
    end
    
    scenario 'Admin upload two images and associate it with existing product, then deletes first one' do
      # TODO: Looks like CarrierWave doesn't support russian file names, fix it
      # expect_to_upload_image 'spec/support/images/красивая картинка.jpg'
      expect_to_upload_image 'spec/support/images/another image.jpg'      

      expect(page).to have_selector 'img', count: 1
      click_link 'Удалить', match: :first

      expect(page).to have_content 'Изобажение удалено'
      expect(page).to have_selector 'img', count: 0
    end

    scenario 'Admin deletes existing product' do
      visit path
      
      expect(page).to have_content product.name
      click_on 'Удалить'

      expect(current_path).to match(admin_products_path)
      expect(page).to_not have_content product.name

      expect { visit admin_product_path(product) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end