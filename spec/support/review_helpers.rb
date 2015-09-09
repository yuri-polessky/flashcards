module ReviewHelpers
  def get_new_review_date(add_time)
    review = Review.new(card_id: card.id, answer: "way")
    new_review_date = review.new_review_date
    Timecop.freeze(Time.current + add_time)
    new_review_date
  end
end