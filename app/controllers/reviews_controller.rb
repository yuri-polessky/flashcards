class ReviewsController < ApplicationController
  
  def new
    card = current_user.cards_for_review.order("RANDOM()").first
    @review = Review.new(card.id) unless card.blank?
  end

  def create
    @review = Review.new(params[:review][:card_id],
      params[:review][:answer], params[:review][:answer_time])

    if @review.check_translation
      flash[:notice] = success_message
      redirect_to root_path
    elsif @review.failed_review_count == 0
      flash[:notice] = t(:three_wrong_answers)
      redirect_to root_path
    else
      flash[:notice] = t(:wrong_answer)
      render :new
    end
  end

  private
  
  def success_message
    if @review.mistyped?
      t(:mistyped_answer, translation: @review.translated_text, correct_answer: @review.original_text, mistyped: @review.answer)
    else
      t(:correct_answer)
    end
  end

end