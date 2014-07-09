class SetDefaultListAndDiscountPriceToNilForVariants < ActiveRecord::Migration
  def change
    remove_money :variants, :list_price
    remove_money :variants, :discount_price
    add_money :variants, :list_price, amount: { null: true, default: nil }
    add_money :variants, :discount_price, amount: { null: true, default: nil }
  end
end
