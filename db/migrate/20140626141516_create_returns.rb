class CreateReturns < ActiveRecord::Migration
  def change
    create_table :returns do |t|
      t.integer :order_id

      t.timestamps
    end
  end
end
