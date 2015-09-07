class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.references :user, index: true
      t.string :name
      t.boolean :current, default: false
    end
  end
end
