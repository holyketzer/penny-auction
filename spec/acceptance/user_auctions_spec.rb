require 'acceptance/acceptance_helper'

feature "User can view auctions", %q{
  In order to buy the products
  As an user
  I want to be able to view auctions
 } do  

  let!(:image) { create(:image) }
  let!(:product) { create(:product, images: [image]) }
  let!(:auction) { create(:auction, image: image, product: product) }

  background do
    visit auctions_path
  end

  scenario 'User views auctions list' do
    expect(page).to have_content 'Аукционы'
      
    within '.list-header' do
      expect(page).to have_content 'Товар'
      expect(page).to have_content 'Изображение'
      expect(page).to have_content 'Начальная цена'
      expect(page).to have_content 'Длительность'
    end
      
    within '.list-item' do
      expect(page).to have_content auction.product.name
      expect(page).to have_content auction.start_price
      expect(page).to have_content auction.duration
      expect(page).to have_xpath("//img[contains(@src, '#{auction.image.thumb_url}')]")
      expect(page).to have_link auction.product.name, auctions_path(auction.product)
    end
  end

  scenario 'User views auction' do
    click_on auction.product.name

    expect(current_path).to be_eql auction_path(auction)
    expect(page).to have_content 'Аукцион'
    expect(page).to have_content auction.product.name
    expect(page).to have_content auction.start_price
    expect(page).to have_content auction.duration
    expect(page).to have_xpath("//img[contains(@src, '#{auction.image.thumb_url}')]")
  end
end