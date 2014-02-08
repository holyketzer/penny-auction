require 'acceptance/acceptance_helper'

feature "Admin can manage auctions", %q{
  In order to sell the products
  As an admin
  I want to be able to manage auctions
 } do  

  let(:path) { admin_auctions_path }
  let(:admin) { create(:admin) }  
  
  let!(:auction) { create(:auction) }
  
  let!(:new_image) { create(:new_image) }
  let!(:new_product) { create(:new_product, images: [new_image]) }

  it_behaves_like "Admin accessible"

  context "admin" do
    background do
      login admin      
    end

    scenario 'Admin views auctions list' do
      visit path

      expect(page).to have_link 'Создать', href: new_admin_auction_path
      expect(page).to have_content 'Аукционы'
      
      within '.list-header' do
        expect(page).to have_content 'Товар'
        expect(page).to have_content 'Изображение'
        expect(page).to have_content 'Начальная цена'
        expect(page).to have_content 'Время начала'
        expect(page).to have_content 'Длительность'
      end
      
      within '.list-item' do
        expect(page).to have_content auction.product.name
        expect(page).to have_content auction.start_price
        expect(page).to have_content auction.start_time
        expect(page).to have_content auction.duration
        expect(page).to have_xpath("//img[contains(@src, '#{auction.image.thumb_url}')]")

        expect(page).to have_link 'Изменить', href: edit_admin_auction_path(auction)
        expect(page).to have_link 'Удалить', href: admin_auction_path(auction)
      end
    end

    scenario 'Admin deletes existing auction' do
      visit path
      
      expect(page).to have_content auction.product.name
      expect { click_on 'Удалить' }.to change(Auction, :count).by(-1)

      expect(current_path).to match(admin_auctions_path)
      expect(page).to_not have_content auction.product.name
    end

    describe 'with AJAX', js: true do
      scenario 'Admin creates new auction' do
        product = auction.product
        new_auction = {
          product_name: product.name, 
          start_price: 1.90,
          start_time: Time.new + 5.minutes,
          min_price: 7770.90,
          duration: 3600, 
          bid_time_step: '1:00',
          bid_price_step: 100.0 
        }
        
        visit new_admin_auction_path

        expect(page).to have_content 'Новый аукцион'

        select new_auction[:product_name], from: 'Товар'
        choose_by_value product.images.first.id        
        fill_in 'Начальная цена', with: new_auction[:start_price]
        fill_in 'Время начала', with: new_auction[:start_time]
        fill_in 'Минимальная цена продажи', with: new_auction[:min_price]
        fill_in 'Длительность', with: new_auction[:duration]
        select new_auction[:bid_time_step], from: 'Шаг увеличения времени'
        fill_in 'Шаг увеличения цены', with: new_auction[:bid_price_step]        
        
        # fails cause Acive Record in different process can't be so fast to track new item, 
        # It works with small sleep, but it isn't acceptable, I should find right way
        # expect { click_on 'Сохранить' }.to change(Auction, :count).by(1)
        click_on 'Сохранить'

        expect_to_be_on_auction_show_page new_auction
        expect(page).to have_content 'Аукцион сохранён'
      end

      scenario 'Admin updates existing auction' do
        updated_auction = {
          product_name: new_product.name,
          start_price: 1.90,
          start_time: Time.new + 17.minutes,
          min_price: 7770.90,
          duration: 3600, 
          bid_time_step: '1:00',
          bid_price_step: 100.0 
        }

        visit edit_admin_auction_path(auction)

        expect(page).to have_content 'Редактирование аукциона'
        expect(page).to have_select 'Товар', :selected => auction.product.name
        have_checked_field_with_value auction.image.id
        expect(page).to have_field 'Начальная цена', :with => auction.start_price      
        expect(page).to have_field 'Минимальная цена продажи', :with => auction.min_price
        expect(page).to have_field 'Длительность', :with => auction.duration
        expect(page).to have_select 'Шаг увеличения времени', :selected => bid_time_step_to_s(auction.bid_time_step)
        expect(page).to have_field 'Шаг увеличения цены', :with => auction.bid_price_step      

        select updated_auction[:product_name], from: 'Товар'        
        choose_by_value new_product.images.first.id        
        fill_in 'Начальная цена', with: updated_auction[:start_price]
        fill_in 'Время начала', with: updated_auction[:start_time]
        fill_in 'Минимальная цена продажи', with: updated_auction[:min_price]
        fill_in 'Длительность', with: updated_auction[:duration]
        select updated_auction[:bid_time_step], from: 'Шаг увеличения времени'
        fill_in 'Шаг увеличения цены', with: updated_auction[:bid_price_step]
        
        expect { click_on 'Сохранить'  }.to change(Product, :count).by(0)
        
        expect_to_be_on_auction_show_page updated_auction
        expect(page).to have_content 'Аукцион сохранён'
      end
    end    
  end

  def expect_to_be_on_auction_show_page(auction)
    expect(current_path).to match(admin_auction_path(id: '.+'))

    expect(page).to have_content 'Товар'
    expect(page).to have_content 'Изображение'
    expect(page).to have_content 'Начальная цена'
    expect(page).to have_content 'Минимальная цена продажи'
    expect(page).to have_content 'Длительность'
    expect(page).to have_content 'Шаг увеличения времени'
    expect(page).to have_content 'Шаг увеличения цены'

    #save_and_open_page
    auction.each_value do |value| 
      value = value.utc if value.kind_of?(Time)
      expect(page).to have_content value
    end
  end
end