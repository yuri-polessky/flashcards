class ReviewsController < ApplicationController
  def new
    card = Card.for_review.order("RANDOM()").limit(1)
    unless card.blank?
      @card = card.first
      @review = Review.new(card_id: @card.id)
    end
  end

  def create
    @card = Card.find(params[:review][:card_id])
    
    if @card.check_translation(params[:review][:answer])
      @card.set_review_date
      @card.save
      flash[:notice] = "Правильно"
    else
      flash[:notice] = "Неправильно"
    end
    redirect_to root_path
  end
end