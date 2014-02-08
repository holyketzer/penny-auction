module Features
  module SessionsHelpers
    def sign_in_with(email, password)
      fill_in 'Email', with: email
      fill_in 'Пароль', with: password
      click_on 'Войти'
    end

    def login(user)      
      visit new_user_session_path
      sign_in_with user.email, user.password
    end
  end
end