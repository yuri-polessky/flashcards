class Review
  attr_accessor :card_id, :answer
  attr_reader :distance
  SPACE_INTERVALS = [12.hours, 3.day, 1.week, 2.week, 1.month]

  def initialize(card_id, answer = nil)
    @answer = answer.strip.mb_chars.downcase if answer
    @card_id = card_id
  end

  def check_translation
    if correct_answer?
      process_correct_answer
      true
    else
      process_incorrect_answer
      false
    end
  end

  def correct_answer?
    @distance = DamerauLevenshtein.distance(answer, original_text)
    distance <= 1
  end

  def mistype?
    distance == 1
  end

  def new_review_date
    Time.current + (SPACE_INTERVALS[card.review_count] || 1.month)
  end

  def review_count
    @review_count ||= card.review_count + 1
  end

  def failed_review_count
    @failed_review_count ||= (card.failed_review_count + 1) % 3
  end

  def process_correct_answer
    card.update(review_date: new_review_date, review_count: review_count)
  end

  def process_incorrect_answer
    card.failed_review_count = failed_review_count
    if failed_review_count == 0
      card.review_count = 1
      card.review_date = Time.current + 12.hours
    end
    card.save
  end

  def card
    @card ||= Card.find(card_id)
  end

  def original_text
    @original_text ||= card.original_text.strip.mb_chars.downcase
  end
end