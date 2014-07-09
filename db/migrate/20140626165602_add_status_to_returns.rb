class AddStatusToReturns < ActiveRecord::Migration
  def change
    add_column :returns, :status, :string
  end
end
