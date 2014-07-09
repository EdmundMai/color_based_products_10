class CreateReturnItems < ActiveRecord::Migration
  def change
    create_table :return_items do |t|
      t.integer :return_id
      t.integer :quantity
      t.integer :line_item_id

      t.timestamps
    end
  end
end
