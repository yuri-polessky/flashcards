class Guest::HomeController < GuestController
  def index
    redirect_to new_review_path if current_user
  end
end
