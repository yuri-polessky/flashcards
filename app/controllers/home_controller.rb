class HomeController < ApplicationController
  def index
    @card_for_review = Card.for_review.sample(1).try(:first)
  end
end
