class Dashboard::ReviewsController < DashboardController
  
  def new
    build_review
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    review = Review.new(review_params)
    review.check_translation

    render json: { state: review.state, message: review.message }
  end

  private

  def build_review
    card = current_user.cards_for_review.order("RANDOM()").first
    @review = (card.blank? ? nil : Review.new(card_id: card.id))
  end

  def review_params
    params.require(:review).permit(:card_id, :answer, :answer_time)
  end
end