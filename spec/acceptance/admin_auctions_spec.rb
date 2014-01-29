require 'spec_helper'

feature "Admin can manage auctions", %q{
  In order to sell the products
  As an admin
  I want to be able to manage auctions
 } do

  let(:path) { admin_auctions_path }
  let(:admin) { create(:admin) }
  let!(:auction) { create(:auction) }

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
  end
end