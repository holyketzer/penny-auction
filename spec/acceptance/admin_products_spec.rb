require 'acceptance/acceptance_helper'

feature 'Admin can manage products', %q{
  In order to sell the products
  As an admin
  I want to be able to manage products
 } do

  let(:path) { admin_products_path }
  let(:admin) { create(:admin) }

  let!(:category) { create(:category) }
  let!(:new_category) { create(:new_category) }
  let!(:product) { create(:product, category: category) }
  let!(:new_product) { build(:new_product, category: new_category) }

  it_behaves_like 'Admin accessible'

  context 'admin' do
    background do
      login admin
    end

    scenario 'Admin views products list' do
      visit path

      expect(page).to have_link 'Создать', href: new_admin_product_path
      expect(page).to have_content 'Товары'

      within '.list-header' do
        expect(page).to have_content 'Название'
        expect(page).to have_content 'Описание'
        expect(page).to have_content 'Цена'
        expect(page).to have_content 'Категория'
      end

      within '.list-item' do
        expect(page).to have_content product.name
        expect(page).to have_content product.description
        expect(page).to have_content product.shop_price
        expect(page).to have_content product.category.name

        expect(page).to have_link 'Изменить', href: edit_admin_product_path(product)
        expect(page).to have_link 'Удалить', href: admin_product_path(product)
      end
    end

    scenario 'Admin creates new product' do
      visit new_admin_product_path

      expect(page).to have_content 'Новый товар'

      fill_in 'Название', with: new_product.name
      fill_in 'Описание', with: new_product.description
      fill_in 'Цена', with: new_product.shop_price
      select new_product.category.name, from: 'Категория'
      expect { click_on 'Сохранить' }.to change(Product, :count).by(1)

      expect_to_be_on_product_show_page new_product
      expect(page).to have_content 'Товар сохранён'
    end

    scenario 'Admin updates existing product' do
      visit edit_admin_product_path(product)

      expect(page).to have_content 'Редактирование товара'
      expect(page).to have_field 'Название', :with => product.name
      expect(page).to have_field 'Описание', :with => product.description
      expect(page).to have_field 'Цена', :with => product.shop_price
      expect(page).to have_select 'Категория', :selected => product.category.name

      fill_in 'Название', with: new_product.name
      fill_in 'Описание', with: new_product.description
      fill_in 'Цена', with: new_product.shop_price
      select new_product.category.name, from: 'Категория'
      expect { click_on 'Сохранить'  }.to change(Product, :count).by(0)

      expect_to_be_on_product_show_page new_product
      expect(page).to have_content 'Товар сохранён'
    end

    scenario 'Admin upload two images and associate it with existing product, then deletes first one' do
      # TODO: Looks like CarrierWave doesn't support russian file names, fix it
      # expect_to_upload_image 'spec/support/images/красивая картинка.jpg'
      images_count = product.images.size
      expect_to_upload_image 'spec/support/images/another image.jpg'

      expect(page).to have_selector 'img', count: images_count + 1
      click_link 'Удалить', match: :first

      expect(page).to have_content 'Изображение удалено'
      expect(page).to have_selector 'img', count: images_count
    end

    scenario 'Admin deletes existing product' do
      visit path

      expect(page).to have_content product.name
      expect { click_on 'Удалить' }.to change(Product, :count).by(-1)

      expect(current_path).to match(admin_products_path)
      expect(page).to_not have_content product.name
    end

    def expect_to_be_on_product_show_page(product)
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

      expect(page).to have_content 'Изображение сохранено'
      expect(page).to have_xpath("//img[contains(@src, '#{File.basename(image_path).gsub(' ', '_')}')]")
    end
  end
end