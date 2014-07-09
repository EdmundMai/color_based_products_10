class AddReasonToReturns < ActiveRecord::Migration
  def change
    add_column :returns, :reason, :text
  end
end
