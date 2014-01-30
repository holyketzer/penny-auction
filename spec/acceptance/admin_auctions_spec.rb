require 'spec_helper'

feature "Admin can manage auctions", %q{
  In order to sell the products
  As an admin
  I want to be able to manage auctions
 } do

  let(:path) { admin_auctions_path }
  let(:admin) { create(:admin) }
  
  let!(:auction) { create(:auction) }
  let!(:product) { auction.product }

  it_behaves_like "Admin accessible"

  context "admin" do
    background do
      visit new_user_session_path
      sign_in_with admin.email, admin.password
    end

    scenario 'Admin views auctions list' do
      visit path

      expect(page).to have_link 'Создать', href: new_admin_auction_path

      expect(page).to have_content 'Аукционы'
      expect(page).to have_selector 'th', :text => 'Товар'
      expect(page).to have_selector 'th', :text => 'Изображение'
      expect(page).to have_selector 'th', :text => 'Начальная цена'
      expect(page).to have_selector 'th', :text => 'Длительность'
      
      expect(page).to have_selector 'td', :text => auction.product.name
      expect(page).to have_selector 'td', :text => auction.start_price
      expect(page).to have_selector 'td', :text => auction.duration

      expect(page).to have_link 'Изменить', href: edit_admin_auction_path(auction)
      expect(page).to have_link 'Удалить', href: admin_auction_path(auction)
    end

    scenario 'Admin creates new auction' do
      visit new_admin_auction_path

      expect(page).to have_content 'Новый аукцион'

      select product.name, from: 'Товар'
      fill_in 'Начальная цена', with: 1.90
      fill_in 'Минимальная цена продажи', with: 7770.90
      fill_in 'Длительность', with: 3600
      select '1 минута', from: 'Шаг увеличения времени'
      fill_in 'Шаг увеличения цены', with: 100.0
      
      expect { click_on 'Сохранить' }.to change(Auction, :count).by(1)

      expect_to_be_on_auction_show_page
      expect(page).to have_content 'Аукцион сохранён'
    end
  end

  def expect_to_be_on_auction_show_page
  end
end