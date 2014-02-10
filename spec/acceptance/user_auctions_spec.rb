require 'acceptance/acceptance_helper'

feature "User can view auctions", %q{
  In order to buy the products
  As an user
  I want to be able to view auctions
 } do  

  context 'general' do    
    let!(:auction) { create(:auction) }

    background do
      visit auctions_path
    end

    scenario 'User views auctions list' do
      expect(page).to have_content 'Аукционы'
        
      within '.list-header' do
        expect(page).to have_content 'Товар'
        expect(page).to have_content 'Изображение'
        expect(page).to have_content 'Текущая цена'
        expect(page).to have_content 'Время до окончания'
      end
        
      within '.list-item' do
        expect(page).to have_content auction.product.name
        expect(page).to have_content auction.price
        expect(page).to have_xpath("//img[contains(@src, '#{auction.image.thumb_url}')]")
        expect(page).to have_link auction.product.name, auctions_path(auction.product)
      end
    end

    scenario 'User views auction' do
      click_on auction.product.name

      expect(current_path).to be_eql auction_path(auction)
      expect(page).to have_content 'Аукцион'
      expect(page).to have_content auction.product.name
      expect(page).to have_content auction.price      
      expect(page).to have_xpath("//img[contains(@src, '#{auction.image.thumb_url}')]")
    end
  end

  context 'status' do
    scenario 'User views not started auction' do
      start_time = Time.now + 10.minutes
      auction = create(:auction, start_time: start_time)
      visit auctions_path

      within '.list-item' do
        expect(page).to have_content "Начало через 10 минут"
      end
    end

    scenario 'User views finished auction' do
      start_time = Time.now - 3.hour
      auction = create(:auction, start_time: start_time, duration: 1.hour)
      visit auctions_path

      within '.list-item' do
        expect(page).to have_content "Закончен около 2 часа назад"
      end
    end

    scenario 'User views active auction' do
      start_time = Time.now - 10.minutes
      auction = create(:auction, start_time: start_time, duration: 30.minutes)
      visit auctions_path

      within '.list-item' do
        expect(page).to have_content "До окончания 20 минут"
      end
    end
  end

  describe 'bidding' do
    let!(:auction) { create(:auction, :active) }

    context 'anonymous user' do
      scenario 'should login to make bids' do
        visit auctions_path
        click_on 'Сделать ставку'
        expect(current_path).to eq new_user_session_path
      end
    end

    context 'authenticated user' do
      let(:user) { create(:user) }
      
      background do
        login user
        visit auctions_path
        click_on 'Сделать ставку'
      end
      
      context 'on not started auction' do
        let!(:auction) { create(:auction, :not_started) }

        scenario 'can not make bid' do
          expect(current_path).to eq auction_path(auction)
          expect(page).to have_content 'Невозможно сделать ставку'
        end
      end

      context 'on finished auction' do
        let!(:auction) { create(:auction, :finished) }

        scenario 'can not make bid' do
          expect(current_path).to eq auction_path(auction)
          expect(page).to have_content 'Невозможно сделать ставку'
        end
      end

      context 'on active auction' do        
        scenario 'makes bid' do
          expect(current_path).to eq auction_path(auction)
          expect(page).to have_content 'Ставка сделана'

          expect(page).to have_content 'Текущая цена'
          expect(page).to have_content auction.price + auction.bid_price_step

          expect(page).to have_content 'Время до окончания'        
          expect(page).to have_content Time.at(auction.time_left + auction.bid_time_step).strftime("%M:%S")
        end

        scenario 'can not bid twice' do
          click_on 'Сделать ставку'

          expect(current_path).to eq auction_path(auction)
          expect(page).to have_content 'Невозможно сделать ставку'
        end
      end
    end

    context 'any user' do            
      scenario 'can view bids' do
        bids = create_list(:bid, 5, auction: auction)
        visit auction_path(auction)

        within '.bids' do
          expect(page).to have_content 'Ставки'
          expect(page).to have_content 'Время'
          expect(page).to have_content 'Цена'
          expect(page).to have_content 'Пользователь'

          price = auction.start_price
          bids.each do |bid|
            price += auction.bid_price_step
            expect_page_to_have_bid(bid, price)
          end
        end        
      end
    end
  end

  def expect_page_to_have_bid(bid, price)
    expect(page).to have_content(bid.user.email)
    expect(page).to have_content(bid.created_at)
    expect(page).to have_content(price)
  end
end