require 'spec_helper'

feature 'Main page', %q{  
  As an user
  I want to have site navigation
  In order to take part in auctions
 } do

  background do
    visit root_path
  end

  scenario "User can navigate" do        
    expect(current_path).to eq(root_path)
    
    expect(page).to have_link 'Аукционы', href: auctions_path, count: 2    
  end
end