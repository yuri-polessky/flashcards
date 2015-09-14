FactoryGirl.define do

  factory :card do
    original_text "way"
    translated_text "путь"
    efactor 2.5
    interval 0
    review_count 0
    failed_review_count 0
    deck
  end

end