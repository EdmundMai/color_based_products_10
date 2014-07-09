
When(/^I visit the admin materials index page$/) do
  visit admin_materials_path
end

Then(/^I should see a list of materials$/) do
  expect(Material.count).to be > 0
  Material.all.each do |material|
    expect(page).to have_content(material.id)
    expect(page).to have_content(material.name)
  end
end


Given(/^an existing material$/) do
  FactoryGirl.create(:material)
end

When(/^I visit the admin materials edit page$/) do
  material = Material.last
  visit edit_admin_material_path(material)
end

When(/^I edit my material$/) do
  fill_in("material[name]", with: "newMaterialName")
end

Then(/^my material should be updated$/) do
  material = Material.last
  expect(material.name).to eq("newMaterialName")
end

When(/^I visit the admin materials new page$/) do
  visit new_admin_material_path
end

When(/^I fill in the form to create a new material$/) do
  fill_in("material[name]", with: "materialName")
end

Then(/^my material should be created$/) do
  expect(Material.count).to be == 1
  material = Material.last
  expect(material.name).to eq("materialName")
end

Then(/^my material should be deleted$/) do
  expect(Material.count).to be == 0
end



