class AddSavingsToOrders < ActiveRecord::Migration
  def change
    add_money :orders, :savings
  end
end
