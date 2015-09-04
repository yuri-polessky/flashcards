class ReviewsController < ApplicationController
  skip_before_filter :require_login, only: :new
  
  def new
    if current_user
      @card = current_user.cards.for_review.order("RANDOM()").first
      @review = Review.new(card_id: @card.id) unless @card.blank?
    end
  end

  def create
    @review = Review.new(review_params)

    if @review.check_translation
      flash[:notice] = "Правильно"
    else
      flash[:notice] = "Неправильно"
    end
    redirect_to root_path
  end

  private
    
  def review_params
    params.require(:review).permit(:card_id, :answer)
  end
end