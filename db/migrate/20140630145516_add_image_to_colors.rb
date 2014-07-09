class AddImageToColors < ActiveRecord::Migration
  def change
    add_column :colors, :image, :string
  end
end
