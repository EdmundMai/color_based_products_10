When(/^I visit the admin discounts page$/) do
  visit admin_discounts_path
end

When(/^I add the last product color to the discount list$/) do
  products_color = ProductsColor.last
  select(products_color.color.name, from: "available_products_for_discounts[ids][]")
  page.all(:link, ">")[0].click
end

When(/^I apply a (\d+) percent discount$/) do |percentage|
  select("#{percentage}%", from: "percentage")
  click_button("Apply Discount")
end

Then(/^that product should now have a (\d+) percent discounted price$/) do |percentage|
  products_color = ProductsColor.last
  expect(products_color.variants.count).to be > 0
  products_color.variants.each do |variant|
    expect(variant.discount_price).to eq(variant.list_price * (1-percentage.to_f/100.00)) 
  end
end

When(/^I add the last collection to the discount list$/) do
  collection = Collection.last
  select(collection.name, from: "available_collections_for_discounts[ids][]")
  page.all(:link, ">")[1].click
end

Then(/^that collection's products should now have a (\d+) percent discounted price$/) do |percentage|
  collection = Collection.last
  expect(collection.products.count).to be > 0
  collection.products.each do |product|
    expect(product.variants.count).to be > 0
    product.variants.each do |variant|
      expect(variant.discount_price).to eq(variant.list_price * (1-percentage.to_f/100.00)) 
    end
  end
end

When(/^I remove all discounts$/) do
  click_button("Remove All Discounts")
end

Then(/^that product should now have no discounts$/) do
  products_color = ProductsColor.last
  expect(products_color.variants.count).to be > 0
  products_color.variants.each do |variant|
    expect(variant.discount_price).to be_nil
  end
end

Then(/^that collection's products should now have no discounts$/) do
collection = Collection.last
expect(collection.products.count).to be > 0
collection.products.each do |product|
  expect(product.variants.count).to be > 0
  product.variants.each do |variant|
    expect(variant.discount_price).to be_nil
  end
end
end