require 'spec_helper'

feature "Admin can manage products", %q{
  In order to sell the products
  As an admin
  I want to be able to manage products
 } do

  let(:path) { admin_products_path }
  let(:admin) { create(:admin) }  
    
  let!(:product) { create(:product) }
  let!(:category) { product.category }

  it_behaves_like "Admin accessible"

  context "admin" do
    background do
      visit new_user_session_path
      sign_in_with admin.email, admin.password
    end

    scenario 'Admin can view products list' do
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

    scenario 'Admin can create new product' do
      visit new_admin_product_path

      expect(page).to have_content 'Новый товар'

      fill_in 'Название', with: 'iPhone 5U'
      fill_in 'Описание', with: 'Новый мега-смартфон'
      fill_in 'Цена', with: '19999.99'
      select category.name, from: 'product[category_id]'
      click_on 'Создать'

      expect(current_path).to match(admin_product_path(id: '.+'))

      expect(page).to have_content 'Название'
      expect(page).to have_content 'Описание'
      expect(page).to have_content 'Цена'
      expect(page).to have_content 'Категория'

      expect(page).to have_content 'iPhone 5U'
      expect(page).to have_content 'Новый мега-смартфон'
      expect(page).to have_content '19999.99'
      expect(page).to have_content category.name
    end
  end
end