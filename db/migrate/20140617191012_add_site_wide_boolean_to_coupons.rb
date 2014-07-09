class AddSiteWideBooleanToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :site_wide, :boolean
  end
end
