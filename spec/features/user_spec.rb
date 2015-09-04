require 'rails_helper'

describe 'User' do

  it "can register" do
    register("user@gmail.com", "pass")

    expect(page).to have_content "Вы успешно зарегистрировались!"
  end

  it "login after succesfull registration" do
    register("user@gmail.com", "pass")

    expect(page).to have_content "Выйти"
  end

  it "can login with correct password" do
    user = create(:user)
    login(user.email, "pass")

    expect(page).to have_content "Успешный вход"
  end

  it "can't login with incorrect password" do
    user = create(:user)

    login(user.email, "***")

    expect(page).to have_content "Вход не удался."
  end
  it "can logout" do
    user = create(:user)
    login(user.email, "pass")

    click_link "Выйти"

    expect(page).to have_content "Успешный выход!"
  end

end