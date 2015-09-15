class AddReviewCountToCards < ActiveRecord::Migration
  def change
    add_column :cards, :review_count, :integer, default: 0
    add_column :cards, :failed_review_count, :integer, default: 0
  end
end
