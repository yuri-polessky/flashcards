class AddEFactortoCards < ActiveRecord::Migration
  def change
    add_column :cards, :efactor, :float, default: 2.5
    add_column :cards, :interval, :integer, default: 0
  end
end
