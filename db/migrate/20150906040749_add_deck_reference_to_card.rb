class AddDeckReferenceToCard < ActiveRecord::Migration
  def change
    remove_reference :cards, :user, index: true
    add_reference :cards, :deck, index: true
  end
end
