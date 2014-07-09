class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.money :minimum_purchase_amount
      t.decimal :value, :precision => 30, :scale => 2
      t.string :type

      t.timestamps
    end
  end
end
