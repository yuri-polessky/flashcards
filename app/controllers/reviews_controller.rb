class ReviewsController < ApplicationController
  
  def new
    build_review
  end

  def create
    @review = Review.new(review_params)
    @review.check_translation
    flash.now[:notice] = message_for_review
    
    build_review unless @review.state == :wrong
    
    respond_to do |format|
      format.js
    end
  end

  private

  def build_review
    card = current_user.cards_for_review.order("RANDOM()").first
    @review = (card.blank? ? nil : Review.new(card_id: card.id))
  end
  
  def message_for_review
    case @review.state
    when :right then t(:correct_answer)
    when :wrong then t(:wrong_answer)
    when :failed then t(:three_wrong_answers)
    when :mistyped
      t(:mistyped_answer, translation: @review.translated_text, correct_answer: @review.original_text, mistyped: @review.answer)
    end
  end

  def review_params
    params.require(:review).permit(:card_id, :answer, :answer_time)
  end
end