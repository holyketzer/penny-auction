require 'acceptance/acceptance_helper'

feature 'Manager', %q{
  As an manager
  I want to manage auction, products and categories
  In order to help admin
 } do

  let(:manager) { create(:manager) }

  let!(:category) { create(:category) }
  let!(:product) { create(:product, category: category) }
  let!(:auction) { create(:auction, product: product) }

  before do
    login manager
    visit admin_root_path
  end

  it_behaves_like 'Auction manager'

  scenario 'Manager see additional buttons' do
    visit admin_root_path

    expect(page).to have_link 'На сайт', href: root_path
    expect(page).to_not have_link 'Пользователи', href: admin_users_path
    expect(page).to_not have_link 'Роли', href: admin_roles_path
  end

  scenario 'can manage products' do
    has_access_to new_admin_product_path
    has_access_to admin_products_path
    has_access_to edit_admin_product_path(product)
  end

  scenario 'can manage categories' do
    has_access_to new_admin_category_path
    has_access_to admin_categories_path
    has_access_to edit_admin_category_path(category)
  end

  scenario 'can manage auctions' do
    has_access_to new_admin_auction_path
    has_access_to admin_auctions_path
    has_access_to edit_admin_auction_path(auction)
  end

  private

  def has_access_to(path)
    visit path
    expect(current_path).to eq path
  end
end