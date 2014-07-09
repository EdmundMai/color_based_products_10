class AddCodeToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :code, :string
  end
end
