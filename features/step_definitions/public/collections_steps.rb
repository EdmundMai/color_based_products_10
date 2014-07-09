When(/^I view that collection$/) do
  collection = Collection.last
  visit collection_path(collection)
end

Then(/^I should see that collection's information$/) do
  collection = Collection.last
  expect(page).to have_content(collection.name)
  expect(collection.products.count).to be > 0
  collection.products.each do |product|
    expect(page).to have_content(product.name)
  end
end