class AddRmaCodeToReturns < ActiveRecord::Migration
  def change
    add_column :returns, :rma_code, :string
  end
end
