
When(/^I visit the admin vendors index page$/) do
  visit admin_vendors_path
end

Then(/^I should see a list of vendors$/) do
  expect(Vendor.count).to be > 0
  Vendor.all.each do |vendor|
    expect(page).to have_content(vendor.id)
    expect(page).to have_content(vendor.name)
  end
end


Given(/^an existing vendor$/) do
  FactoryGirl.create(:vendor)
end

When(/^I visit the admin vendors edit page$/) do
  vendor = Vendor.last
  visit edit_admin_vendor_path(vendor)
end

When(/^I edit my vendor$/) do
  fill_in("vendor[name]", with: "newVendorName")
end

Then(/^my vendor should be updated$/) do
  vendor = Vendor.last
  expect(vendor.name).to eq("newVendorName")
end

When(/^I visit the admin vendors new page$/) do
  visit new_admin_vendor_path
end

When(/^I fill in the form to create a new vendor$/) do
  fill_in("vendor[name]", with: "vendorName")
end

Then(/^my vendor should be created$/) do
  expect(Vendor.count).to be == 1
  vendor = Vendor.last
  expect(vendor.name).to eq("vendorName")
end

Then(/^my vendor should be deleted$/) do
  expect(Vendor.count).to be == 0
end



