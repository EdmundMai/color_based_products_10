class AddUserIdToReturns < ActiveRecord::Migration
  def change
    add_column :returns, :user_id, :integer
  end
end
