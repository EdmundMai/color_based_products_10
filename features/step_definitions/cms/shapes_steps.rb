
When(/^I visit the admin shapes index page$/) do
  visit admin_shapes_path
end

Then(/^I should see a list of shapes$/) do
  expect(Shape.count).to be > 0
  Shape.all.each do |shape|
    expect(page).to have_content(shape.id)
    expect(page).to have_content(shape.name)
  end
end


Given(/^an existing shape$/) do
  FactoryGirl.create(:shape)
end

When(/^I visit the admin shapes edit page$/) do
  shape = Shape.last
  visit edit_admin_shape_path(shape)
end

When(/^I edit my shape$/) do
  fill_in("shape[name]", with: "newShapeName")
end

Then(/^my shape should be updated$/) do
  shape = Shape.last
  expect(shape.name).to eq("newShapeName")
end

When(/^I visit the admin shapes new page$/) do
  visit new_admin_shape_path
end

When(/^I fill in the form to create a new shape$/) do
  fill_in("shape[name]", with: "shapeName")
end

Then(/^my shape should be created$/) do
  expect(Shape.count).to be == 1
  shape = Shape.last
  expect(shape.name).to eq("shapeName")
end

Then(/^my shape should be deleted$/) do
  expect(Shape.count).to be == 0
end



