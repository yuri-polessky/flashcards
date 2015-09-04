module UserHelper
  def login(email,password)
    visit root_path
    click_link "Войти"
    fill_in :signin_email, with: email
    fill_in :signin_password, with: password
    click_button "Войти"
  end

  def register(email,password)
    visit root_path
    click_link "Зарегистрироваться"
    fill_in :user_email, with: email
    fill_in :user_password, with: password
    fill_in :user_password_confirmation, with: password
    click_button "Create User"
  end
end