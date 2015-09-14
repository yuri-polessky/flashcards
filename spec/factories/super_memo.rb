FactoryGirl.define do

  factory :super_memo do
    efactor 2.5
    quality 5
    interval 0
    review_count 0

    initialize_with { new(efactor, quality, interval, review_count)}
  end

end