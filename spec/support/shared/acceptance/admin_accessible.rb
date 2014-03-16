shared_examples_for "Admin accessible" do
  background do
    visit path
  end

  scenario 'Admin tries to get an access' do
    sign_in_with admin.email, admin.password
    expect(page).to_not have_content "У вас нет прав доступа к этой странице"
    expect(current_path).to_not eq(new_user_session_path)
  end

  scenario 'Non-admin user tries to get access' do
    user = create(:user)
    sign_in_with user.email, user.password
    expect(page).to have_content "У вас нет прав доступа к этой странице"
  end
end

shared_examples_for 'Auction manager' do
  before { visit admin_root_path }

  scenario 'can see all auction managing related links' do
    expect(current_path).to eq(admin_root_path)
    expect(page).to have_content 'Панель управления'
    expect(page).to have_link 'Аукционы', href: admin_auctions_path, count: 2
    expect(page).to have_link 'Категории', href: admin_categories_path, count: 2
    expect(page).to have_link 'Товары', href: admin_products_path, count: 2
  end
end