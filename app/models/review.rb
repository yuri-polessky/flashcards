class Review
  attr_accessor :card_id, :answer, :answer_time
  attr_reader :distance
  
  delegate :efactor, :interval, :review_count, :failed_review_count,
    :translated_text, to: :card

  def initialize(card_id, answer = nil, answer_time = nil)
    @answer = answer.strip.mb_chars.downcase if answer
    @card_id = card_id
    @answer_time = answer_time
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

  def typos_count
    @typos_count ||= DamerauLevenshtein.distance(answer, original_text)
  end

  def mistyped?
    typos_count == 1
  end

  def quality
    return 0 if failed_review_count == 3 || typos_count > 1
    @quality = 5 - failed_review_count - [(answer_time.to_i/30),2].min - typos_count
  end

  def original_text
    @original_text ||= card.original_text.strip.mb_chars.downcase
  end

  def card
    @card ||= Card.find(card_id)
  end

  private
  
  def correct_answer?
    typos_count <= 1
  end

  def new_card_params
    super_memo = SuperMemo.new(efactor,quality,interval,review_count)
    super_memo.get_new_params
  end

  def process_correct_answer
    card.update(new_card_params)
  end

  def process_incorrect_answer
    failed_review_count = self.failed_review_count + 1
    if failed_review_count == 3
      card.update(new_card_params.merge({ failed_review_count: 0 }) )
    else
      card.update(failed_review_count: failed_review_count)
    end
  end
end