require 'acceptance/acceptance_helper'

feature 'Main page', %q{  
  As an user
  I want to have site navigation
  In order to take part in auctions
 } do

  background do
    visit root_path
  end

  scenario 'User can navigate' do        
    expect(current_path).to eq(root_path)
    
    expect(page).to have_link 'Аукционы', href: auctions_path, count: 2
  end

  describe '"admin mode" button' do
    let(:user) { create(:user) }
    let(:admin) { create(:admin) }

    scenario 'admin can see button' do
      login admin
      visit root_path
      expect(page).to have_link 'В админку', href: admin_root_path
    end

    scenario 'user can not see button' do
      login user
      visit root_path
      expect(page).to_not have_link 'В админку', href: admin_root_path
    end
  end
end