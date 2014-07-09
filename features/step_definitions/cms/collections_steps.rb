Given(/^existing collections$/) do
  FactoryGirl.create_list(:collection, 2)
end

Given(/^an existing collection$/) do
  FactoryGirl.create(:collection)
end

Given(/^an existing collection with a product associated with it$/) do
  FactoryGirl.create(:collection_with_a_product)
end

Given(/^an existing collection with a complete product associated with it$/) do
  FactoryGirl.create(:collection_with_a_complete_product, active: true)
end

When(/^I visit the admin collections new page$/) do
  visit new_admin_collection_path
end

When(/^I fill in the form to create a new collection$/) do
  fill_in("collection[name]", with: "Lorem")
  fill_in("collection[short_description]", with: "Ipsum")
  fill_in("collection[long_description]", with: "LongDesc")
end

Then(/^my collection should be created$/) do
  expect(Collection.count).to eq(1)
  collection = Collection.last
  expect(collection.name).to eq("Lorem")
  expect(collection.short_description).to eq("Ipsum")
  expect(collection.long_description).to eq("LongDesc")
  expect(collection.active).to be_false
end


When(/^I visit the admin collections index page$/) do
  visit admin_collections_path
end

Then(/^I should see a list of collections$/) do
  expect(Collection.count).not_to be == 0
  Collection.all.each do |collection|
    expect(page).to have_content(collection.id)
    expect(page).to have_content(collection.name)
  end
end

When(/^I visit the admin collections edit page$/) do
  collection = Collection.last
  visit edit_admin_collection_path(collection)
end

When(/^I edit the collection$/) do
  fill_in("collection[name]", with: "newName")
  fill_in("collection[short_description]", with: "newShortDesc")
  fill_in("collection[long_description]", with: "newLongDesc")
end

When(/^I make the collection active$/) do
  choose("collection_active_true")
end

Then(/^my collection should be updated$/) do
  collection = Collection.last
  expect(collection.name).to eq("newName")
  expect(collection.short_description).to eq("newShortDesc")
  expect(collection.long_description).to eq("newLongDesc")
  expect(collection.active).to be_true
end

Then(/^my collection should be deleted$/) do
  expect(Collection.count).to be == 0
end

When(/^I add a product to my collection$/) do
  select(Product.last.name, from: "unassociated_product_ids[]")
  click_link(">")
  sleep 1
end

Then(/^my collection should have a product$/) do
  collection = Collection.last
  expect(collection.products.count).to be == 1
end

When(/^I remove a product from my collection$/) do
  collection = Collection.last
  select(collection.products.last.name, from: "associated_product_ids[]")
  click_link("<")
  sleep 1
end

Then(/^my collection should have no products$/) do
  collection = Collection.last
  expect(collection.products.count).to be == 0
end

Then(/^that product should not be on the available products list$/) do
  expect(page).not_to have_select("unassociated_product_ids[]", with_options: [Product.last.name])
end

Then(/^that product should be on the chosen products list$/) do
  expect(page).to have_select("associated_product_ids[]", with_options: [Product.last.name])
end

Then(/^that product should be on the available products list$/) do
  expect(page).not_to have_select("associated_product_ids[]", with_options: [Product.last.name])
end

Then(/^that product should not be on the chosen products list$/) do
  expect(page).to have_select("unassociated_product_ids[]", with_options: [Product.last.name])
end

When(/^I search for an available product's name$/) do
  product = Product.last
  fill_in("product_name_search", with: product.name)
  find(:id, 'product_name_search').native.send_keys(:enter)
end

When(/^I search for a product that already exists in my chosen products$/) do
  collection = Collection.last
  fill_in("product_name_search", with: collection.products.last.name)
  find(:id, 'product_name_search').native.send_keys(:enter)
end

Then(/^there should be no available products results$/) do
  expect(page).to have_select("unassociated_product_ids[]", options: [])
end

When(/^I reset my product search$/) do
  click_link("Reset")
end

Then(/^the available products list should be reset$/) do
  collection = Collection.last
  unassociated_products = Product.all.offset(collection.products.count)
  expect(unassociated_products.count).to be > 0
  expect(page).to have_select("unassociated_product_ids[]", with_options: unassociated_products.map(&:name))
end
