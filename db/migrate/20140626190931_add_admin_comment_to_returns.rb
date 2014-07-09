class AddAdminCommentToReturns < ActiveRecord::Migration
  def change
    add_column :returns, :admin_comment, :text
  end
end
