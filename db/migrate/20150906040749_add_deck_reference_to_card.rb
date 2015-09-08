class AddDeckReferenceToCard < ActiveRecord::Migration
  def change
    remove_reference :cards, :user, index: true
    add_reference :cards, :deck, index: true
    add_column :users, :current_deck_id, :integer
    add_index :users, :current_deck_id
  end
end
