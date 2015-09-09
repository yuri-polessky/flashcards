class Review
  include ActiveModel::Model
  attr_accessor :card_id, :answer
  SPACE_INTERVALS = [12.hours,3.day,1.week,2.week,1.month]

  def check_translation
    update_card
    answer_correct?
  end

  def new_review_date
    Time.current + SPACE_INTERVALS[card.review_count]
  end

  def review_count
    @review_count ||= card.review_count + 1
  end

  def failed_review_count
    @failed_review_count ||= (card.failed_review_count + 1)%3
  end

  def answer_correct?
    @answer_correct ||= answer.strip.mb_chars.downcase == original_text.strip.mb_chars.downcase
  end

  def update_card
    if answer_correct?
      card.review_date = new_review_date
      card.review_count = review_count
    else
      card.failed_review_count = failed_review_count
      if failed_review_count == 0
        card.review_count = 1
        card.review_date = Time.current + 12.hours
      end
    end
    card.save
  end

  def card
    @card ||= Card.find(card_id)
  end

  def original_text
    @original_text ||= card.original_text
  end
end