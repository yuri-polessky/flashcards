class AddPictureToCards < ActiveRecord::Migration
  def change
    add_attachment :cards, :picture
  end
end
