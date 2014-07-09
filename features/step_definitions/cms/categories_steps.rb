
When(/^I visit the admin categories index page$/) do
  visit admin_categories_path
end

Then(/^I should see a list of categories$/) do
  expect(Category.count).to be > 0
  Category.all.each do |category|
    expect(page).to have_content(category.id)
    expect(page).to have_content(category.name)
  end
end


Given(/^an existing category$/) do
  FactoryGirl.create(:category)
end

When(/^I visit the admin categories edit page$/) do
  category = Category.last
  visit edit_admin_category_path(category)
end

When(/^I edit my category$/) do
  fill_in("category[name]", with: "newCategoryName")
end

Then(/^my category should be updated$/) do
  category = Category.last
  expect(category.name).to eq("newCategoryName")
end

When(/^I visit the admin categories new page$/) do
  visit new_admin_category_path
end

When(/^I fill in the form to create a new category$/) do
  fill_in("category[name]", with: "categoryName")
end

Then(/^my category should be created$/) do
  expect(Category.count).to be == 1
  category = Category.last
  expect(category.name).to eq("categoryName")
end

Then(/^my category should be deleted$/) do
  expect(Category.count).to be == 0
end



