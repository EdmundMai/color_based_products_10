Given(/^existing coupons$/) do
  FactoryGirl.create(:free_shipping_coupon)
  FactoryGirl.create(:percentage_coupon)
  FactoryGirl.create(:flat_coupon)
end

Given(/^an existing flat coupon$/) do
  FactoryGirl.create(:flat_coupon)
end

Given(/^an existing free shipping coupon$/) do
  FactoryGirl.create(:free_shipping_coupon)
end

Given(/^an existing percentage coupon$/) do
  FactoryGirl.create(:percentage_coupon)
end

Given(/^an existing site wide flat coupon$/) do
  FactoryGirl.create(:flat_coupon, site_wide: true)
end

Given(/^an existing site wide flat coupon with an enormous minimum purchase amount$/) do
  FactoryGirl.create(:flat_coupon, site_wide: true, minimum_purchase_amount: 9999.99)
end


When(/^I visit the admin coupons index page$/) do
  visit admin_coupons_path
end

Then(/^I should see a list of coupons information$/) do
  expect(Coupon.count).to be > 0
  Coupon.all.each do |coupon|
    expect(page).to have_content(coupon.name)
    expect(page).to have_content(coupon.value_prettified)
    expect(page).to have_content(coupon.code)
  end
end

When(/^I visit the admin coupons new page$/) do
  visit new_admin_coupon_path
end

When(/^I fill in the form to create a new free shipping coupon$/) do
  fill_in("coupon[name]", with: "Spring Sale")
  fill_in("coupon[code]", with: "ABC123")
  select("Free Shipping", from: "coupon[type]")
  expect(page).not_to have_select("coupon[value]")
  select("$5.00", from: "coupon[minimum_purchase_amount]")
  fill_in("coupon[start_date]", with: Date.today.strftime("%m/%d/%Y"))
  fill_in("coupon[end_date]", with: Date.tomorrow.strftime("%m/%d/%Y"))
  check("Site wide")
end

Then(/^my free shipping coupon should be saved$/) do
  expect(FreeShippingCoupon.count).to eq(1)
  
  free_shipping_coupon = FreeShippingCoupon.last
  expect(free_shipping_coupon.name).to eq("Spring Sale")
  expect(free_shipping_coupon.type).to eq("FreeShippingCoupon")
  expect(free_shipping_coupon.value).to eq(0.00)
  expect(free_shipping_coupon.minimum_purchase_amount).to eq(5.00)
  expect(free_shipping_coupon.start_date).to eq(Date.today)
  expect(free_shipping_coupon.end_date).to eq(Date.tomorrow)
  expect(free_shipping_coupon.site_wide).to be_true
  expect(free_shipping_coupon.code).to eq("ABC123")
end

When(/^I fill in the form to create a new percentage coupon$/) do
  fill_in("coupon[name]", with: "Summer Sale")
  fill_in("coupon[code]", with: "ABC123")
  select("Percentage Amount", from: "coupon[type]")
  select("10.00%", from: "coupon[value]")
  select("$15.00", from: "coupon[minimum_purchase_amount]")
  fill_in("coupon[start_date]", with: Date.today.strftime("%m/%d/%Y"))
  fill_in("coupon[end_date]", with: Date.tomorrow.strftime("%m/%d/%Y"))
  check("Site wide")
end

Then(/^my percentage coupon should be saved$/) do
  expect(PercentageCoupon.count).to eq(1)
  
  percentage_coupon = PercentageCoupon.last
  expect(percentage_coupon.name).to eq("Summer Sale")
  expect(percentage_coupon.type).to eq("PercentageCoupon")
  expect(percentage_coupon.value).to eq(10.00)
  expect(percentage_coupon.minimum_purchase_amount).to eq(15.00)
  expect(percentage_coupon.start_date).to eq(Date.today)
  expect(percentage_coupon.end_date).to eq(Date.tomorrow)
  expect(percentage_coupon.site_wide).to be_true
  expect(percentage_coupon.code).to eq("ABC123")
end

When(/^I fill in the form to create a new flat coupon$/) do
  fill_in("coupon[name]", with: "Fall Sale")
  fill_in("coupon[code]", with: "ABC123")
  select("Flat Amount", from: "coupon[type]")
  select("$15.00", from: "coupon[value]")
  select("$25.00", from: "coupon[minimum_purchase_amount]")
  fill_in("coupon[start_date]", with: Date.today.strftime("%m/%d/%Y"))
  fill_in("coupon[end_date]", with: Date.tomorrow.strftime("%m/%d/%Y"))
  check("Site wide")
end

Then(/^my flat coupon should be saved$/) do
  expect(FlatCoupon.count).to eq(1)
  
  flat_coupon = FlatCoupon.last
  expect(flat_coupon.name).to eq("Fall Sale")
  expect(flat_coupon.type).to eq("FlatCoupon")
  expect(flat_coupon.value).to eq(15.00)
  expect(flat_coupon.minimum_purchase_amount).to eq(25.00)
  expect(flat_coupon.start_date).to eq(Date.today)
  expect(flat_coupon.end_date).to eq(Date.tomorrow)
  expect(flat_coupon.site_wide).to be_true
  expect(flat_coupon.code).to eq("ABC123")
end

When(/^I visit the admin coupons show page$/) do
  coupon = Coupon.last
  visit admin_coupon_path(coupon)
end

Then(/^I should see the coupon's information$/) do
  coupon = Coupon.last
  expect(page).to have_content(coupon.name)
  expect(page).to have_content(coupon.value_prettified)
  expect(page).to have_content(coupon.minimum_purchase_amount)
  expect(page).to have_content(coupon.start_date.strftime("%m/%d/%Y"))
  expect(page).to have_content(coupon.end_date.strftime("%m/%d/%Y"))
end

When(/^I visit the admin coupons edit page$/) do
  coupon = Coupon.last
  visit edit_admin_coupon_path(coupon)
end

When(/^I change the coupon's attributes$/) do
  fill_in("coupon[name]", with: "Summer Sale")
  select("Percentage Amount", from: "coupon[type]")
  select("10.00%", from: "coupon[value]")
  select("$15.00", from: "coupon[minimum_purchase_amount]")
  fill_in("coupon[start_date]", with: Date.today.strftime("%m/%d/%Y"))
  fill_in("coupon[end_date]", with: Date.tomorrow.strftime("%m/%d/%Y"))
  check("Site wide")
end

Then(/^my coupon should be updated$/) do
  percentage_coupon = PercentageCoupon.last
  expect(percentage_coupon.name).to eq("Summer Sale")
  expect(percentage_coupon.type).to eq("PercentageCoupon")
  expect(percentage_coupon.value).to eq(10.00)
  expect(percentage_coupon.minimum_purchase_amount).to eq(15.00)
  expect(percentage_coupon.start_date).to eq(Date.today)
  expect(percentage_coupon.end_date).to eq(Date.tomorrow)
  expect(percentage_coupon.site_wide).to be_true
end

When(/^I click "(.*?)"$/) do |link_text|
  click_link(link_text)
end

Then(/^my coupon should be deleted$/) do
  expect(Coupon.count).to eq(0)
end

Then(/^my coupon should not be created$/) do
  expect(Coupon.count).to eq(0)
end

Then(/^I should still see the new coupon form$/) do
  expect(current_path).to eq(admin_coupons_path)
end


