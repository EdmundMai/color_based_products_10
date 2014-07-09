Given(/^an existing color$/) do
  FactoryGirl.create(:color)
end


When(/^I visit the admin color new page$/) do
  visit new_admin_color_path
end

When(/^I fill out the form to create a color$/) do
  fill_in("color[name]", with: "myColorName")
  attach_file('color[image]', File.join(Rails.root, 'spec', 'support', 'sample_img.jpg'))
end

Then(/^my color should be created$/) do
  expect(Color.count).to be == 1
  color = Color.last
  expect(color.name).to eq "myColorName"
  expect(color.image).not_to be_nil
end

When(/^I visit the admin color index page$/) do
  visit admin_colors_path
end

Then(/^I should see a list of colors$/) do
  expect(Color.count).to be > 0
  Color.all.each do |color|
    expect(page).to have_content(color.name)
  end
end


When(/^I visit the admin color edit page$/) do
  color = Color.last
  visit edit_admin_color_path(color)
end

When(/^I edit the color$/) do
  fill_in("color[name]", with: "new color name")
  click_link("Delete Image")
end

Then(/^my color should be updated$/) do
  color = Color.last
  expect(color.name).to eq "new color name"
  expect(color.image).not_to be_nil
end

Then(/^my color should be deleted$/) do
  expect(Color.count).to be == 0
end

