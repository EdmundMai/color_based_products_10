class AddAmountToReturns < ActiveRecord::Migration
  def change
    add_money :returns, :amount
  end
end
