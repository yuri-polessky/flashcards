class Review
  attr_accessor :card_id, :answer, :answer_time

  delegate :efactor, :interval, :review_count, :failed_review_count,
           :translated_text, :original_text, to: :card

  def initialize(args)
    @answer = args[:answer]
    @card_id = args[:card_id]
    @answer_time = args[:answer_time]
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

  def mistyped?
    typos_count == 1
  end

  # Each 30 seconds reduce quality to 1 point, but no more than 2 point.
  # Mistyped answer reduce quality to 1 point.
  # Each wrong answer reduce quality to 1.
  # Quality is zero when user made three wrong answers in row.
  def quality
    return 0 if failed_answer?
    @quality ||= 5 - failed_review_count - [(answer_time.to_i / 30), 2].min - typos_count
  end

  def card
    @card ||= Card.find(card_id)
  end

  private
  
  def typos_count
    @typos_count ||= DamerauLevenshtein.distance(normalize_utf(answer), normalize_utf(original_text))
  end

  def failed_answer?
    failed_review_count == 3
  end

  def correct_answer?
    typos_count <= 1
  end

  def normalize_utf(text)
    text.strip.mb_chars.downcase
  end

  def new_card_params
    SuperMemo.call(efactor, quality, interval, review_count)
  end

  def process_correct_answer
    card.update(new_card_params)
  end

  def process_incorrect_answer
    card.failed_review_count += 1
    if failed_answer?
      card.update(new_card_params.merge({ failed_review_count: 0 }))
    else
      card.update(failed_review_count: failed_review_count)
    end
  end
end