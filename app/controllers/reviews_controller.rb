class ReviewsController < ApplicationController
  
  def new
    #@card = current_user.cards.for_review.order("RANDOM()").first
    @card = current_user.cards.order("RANDOM()").first
    @review = Review.new(card_id: @card.id) unless @card.blank?
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