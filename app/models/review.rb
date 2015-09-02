class Review
  include ActiveModel::Model
  attr_accessor :card_id, :answer

  def check_translation
    if answer.strip.mb_chars.downcase == original_text.strip.mb_chars.downcase
      card.set_review_date
      card.save
      true
    else
      false
    end
  end

  def card
    @card ||= Card.find(card_id)
  end

  def original_text
    @original_text ||= card.original_text
  end
end