class ReviewsController < ApplicationController
  
  def new
    card = current_user.cards_for_review.order("RANDOM()").first
    @review = Review.new(card_id: card.id) unless card.blank?
  end

  def create
    @review = Review.new(review_params)

    if @review.check_translation
      flash[:notice] = "Правильно"
      redirect_to root_path
    elsif @review.failed_review_count == 0
      flash[:notice] = "Три неправильных ответа подряд. Срок проверки карточки обнулен."
      redirect_to root_path
    else
      flash[:notice] = "Неправильно."
      render :new
    end
  end

  private
    
  def review_params
    params.require(:review).permit(:card_id, :answer)
  end
end