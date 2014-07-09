class SplitPriceIntoListPriceAndDiscountPriceForVariants < ActiveRecord::Migration
  def change
    remove_money :variants, :price
    add_money :variants, :list_price
    add_money :variants, :discount_price
  end
end
