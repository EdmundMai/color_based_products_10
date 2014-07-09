Given(/^an existing active product with instock variants$/) do
  FactoryGirl.create(:complete_product, active: true)
end

Given(/^an existing user$/) do
  FactoryGirl.create(:user, guest: false)
end

When(/^I fill in the form to log in at the checkout page$/) do
  within(".user_info") do
    click_link("Log in")
  end
  
  fill_in("user[email]", with: User.where(guest: [false, nil]).last.email)
  fill_in("user[password]", with: "test123")
end


When(/^I visit the product show page$/) do
  product = Product.last
  visit product_path(product)
end

When(/^I add that product to my cart$/) do
  first(:button, "Add to cart").click
end

Then(/^my cart should have one item$/) do
  user = User.last
  expect(user.cart.cart_items.count).to eq(1)
end

Then(/^my permanent user cart should have one item$/) do
  sleep 1
  user = User.where(guest: [false,nil]).last
  expect(user.cart.cart_items.count).to eq(1)
end

Then(/^the quantity of my cart item should be (\d+)$/) do |quantity|
  user = User.last
  expect(user.cart.cart_items.last.quantity).to eq(2)
end

Then(/^I should be on the shopping cart page$/) do
  expect(current_path).to eq(checkout_path)
end

Given(/^an existing item in my cart$/) do
  product = FactoryGirl.create(:complete_product, active: true)
  visit product_path(product)
  first(:button, "Add to cart").click
end

Then(/^there shouldn't be a form to create an account$/) do
  expect(page).not_to have_field("user[email]")
  expect(page).not_to have_field("user[password]")
end

When(/^I visit the shopping cart page$/) do
  visit checkout_path
end

When(/^I remove an item from my cart$/) do
  first(:link, "X").click
end

Then(/^my cart should have no items$/) do
  user = User.last
  expect(user.cart.cart_items).to be_empty
end

Then(/^I should see a "(.*?)" link$/) do |link_text|
  expect(page).to have_link(link_text)
end

When(/^I checkout$/) do
  click_link("Checkout")
end

When(/^I fill in the form to create a new account$/) do
  fill_in("payment_info[email]", with: "abc123@nettheory.com")
  expect(page).not_to have_field("payment_info[password]")
  check("Create an account")
  expect(page).to have_field("payment_info[password]")
  fill_in("payment_info[password]", with: "test123")
end

Given(/^an existing state$/) do
  FactoryGirl.create(:state)
end

Given(/^an existing New York state$/) do
  FactoryGirl.create(:new_york_state)
end

Given(/^an existing tax for zip code "(.*?)"$/) do |zip_code|
  FactoryGirl.create(:tax, zip_code: zip_code, state_id: State.new_york.id)
end

When(/^I fill in a valid shipping address$/) do
  fill_in("payment_info[shipping_address_first_name]", with: "Lorem")
  fill_in("payment_info[shipping_address_last_name]", with: "Ipsum")
  fill_in("payment_info[shipping_address_street_address]", with: "123 Fake Street")
  fill_in("payment_info[shipping_address_street_address2]", with: "12")
  fill_in("payment_info[shipping_address_city]", with: "New York")
  select(State.new_york.short_name, from: "payment_info[shipping_address_state_id]")
  fill_in("payment_info[shipping_address_zip_code]", with: Tax.last.zip_code)
  fill_in("payment_info[shipping_address_phone_number]", with: "1231231234")
end

When(/^I fill in a valid billing address$/) do
  fill_in("payment_info[billing_address_first_name]", with: "Lorem")
  fill_in("payment_info[billing_address_last_name]", with: "Ipsum")
  fill_in("payment_info[billing_address_street_address]", with: "123 Fake Street")
  fill_in("payment_info[billing_address_street_address2]", with: "12")
  fill_in("payment_info[billing_address_city]", with: "New York")
  select(State.new_york.short_name, from: "payment_info[billing_address_state_id]")
  fill_in("payment_info[billing_address_zip_code]", with: Tax.last.zip_code)
  fill_in("payment_info[billing_address_phone_number]", with: "1231231234")
end

When(/^I fill in a valid credit card$/) do
  fill_in("payment_info[credit_card_number]", with: "4111111111111111")
  select("12", from: "payment_info[credit_card_exp_mm]")
  select((Date.today.year + 1).to_s, from: "payment_info[credit_card_exp_yyyy]")
  fill_in("payment_info[credit_card_cvv]", with: "123")
end

When(/^I press "(.*?)"$/) do |button_text|
  click_button(button_text)
end

When(/^I submit my order$/) do
  click_button("Submit Order")
  sleep 2
end

Then(/^the review button should be enabled$/) do
  expect(find("#review_order_button")[:disabled]).to be_false
end

Then(/^the submit order button should be disabled$/) do
  expect(find("#submit_order_button")[:disabled]).to be_true
end

Then(/^the edit payment info button should be disabled$/) do
  expect(find("#edit_payment_info_button")[:disabled]).to be_true
end

# When(/^I fill in the form to create a new account incorrectly$/) do
#   check("Create an account")
# end

When(/^I fill in a invalid shipping address$/) do
  select(State.new_york.short_name, from: "payment_info[shipping_address_state_id]")
end

When(/^I fill in a invalid billing address$/) do
  # do nothing
end

When(/^I fill in a invalid credit card$/) do
  # do nothing
end

Then(/^I should see errors for my payment info$/) do
  expect(page).to have_content("Shipping address first name can't be blank")
  expect(page).to have_content("Shipping address last name can't be blank")
  expect(page).to have_content("Shipping address street address can't be blank")
  expect(page).to have_content("Shipping address apt/suite can't be blank")
  expect(page).to have_content("Shipping address zip code can't be blank")
  expect(page).to have_content("Shipping address city can't be blank")
  expect(page).to have_content("Shipping address phone number can't be blank")
  expect(page).to have_content("Billing address first name can't be blank")
  expect(page).to have_content("Billing address last name can't be blank")
  expect(page).to have_content("Billing address street address can't be blank")
  expect(page).to have_content("Billing address apt/suite can't be blank")
  expect(page).to have_content("Billing address zip code can't be blank")
  expect(page).to have_content("Billing address city can't be blank")
  expect(page).to have_content("Billing address phone number can't be blank")
  expect(page).to have_content("Credit card number can't be blank")
  expect(page).to have_content("Credit card cvv can't be blank")
  expect(page).to have_content("The zip code you entered is invalid. Please try again.")
end

Then(/^the review button should be disabled$/) do
  expect(find("#review_order_button")[:disabled]).to be_true
end

Then(/^my permanent user cart should be empty$/) do
  user = User.where(guest: [false,nil]).last
  expect(user.cart.cart_items).to be_empty
end


Then(/^my order should be placed$/) do
  expect(Order.in_progress_or_shipped.count).to eq(1)
  
  order = Order.last
  
  expect(order.status).to eq(Order::IN_PROGRESS)
  expect(order.order_date).to eq(Date.today)
  
  expect(order.shipping_address).not_to be_nil
  expect(order.shipping_address.first_name).to eq("Lorem")
  expect(order.shipping_address.last_name).to eq("Ipsum")
  expect(order.shipping_address.street_address).to eq("123 Fake Street")
  expect(order.shipping_address.street_address2).to eq("12")
  expect(order.shipping_address.state).to eq(State.new_york)
  expect(order.shipping_address.zip_code).to eq(Tax.last.zip_code)
  expect(order.shipping_address.phone_number).to eq("1231231234")

  expect(order.billing_address).not_to be_nil
  expect(order.shipping_address.first_name).to eq("Lorem")
  expect(order.shipping_address.last_name).to eq("Ipsum")
  expect(order.shipping_address.street_address).to eq("123 Fake Street")
  expect(order.shipping_address.street_address2).to eq("12")
  expect(order.shipping_address.state).to eq(State.new_york)
  expect(order.shipping_address.zip_code).to eq(Tax.last.zip_code)
  expect(order.shipping_address.phone_number).to eq("1231231234")
  
  expect(order.line_items).not_to be_empty
  line_item = order.line_items.last
  expect(line_item.quantity).to be == 1
  expect(line_item.unit_price).to be == Variant.last.price
end

Then(/^my guest cookie should be deleted$/) do
  if Capybara.current_session.driver.class == Capybara::Selenium::Driver
    expect(page.driver.browser.manage.cookie_named('guest_id')).to be_nil
  else
    expect(Capybara.current_session.driver.request.cookies.[]('guest_id')).to be_nil
  end
end

Then(/^my user should be updated$/) do
  order = Order.last
  user = order.user
  expect(user.email).to eq("abc123@yahoo.com")
  expect(user.guest?).to be_false
  expect(user.cart.cart_items).to be_empty
end


Then(/^I should receive an order confirmation email$/) do
  order = Order.last
  expect(ActionMailer::Base.deliveries.count).to eq(1)
  expect(ActionMailer::Base.deliveries.first.to).to match_array [order.user.email]
end

When(/^I enter a valid free shipping coupon code$/) do
  free_shipping_coupon = FreeShippingCoupon.last
  fill_in("payment_info[coupon_code]", with: free_shipping_coupon.code)
end

Then(/^my shipping should be set to zero$/) do
  order = Order.last
  expect(order.shipping).to eq(0)
end

When(/^I enter a valid flat coupon code$/) do
  flat_coupon = FlatCoupon.last
  fill_in("payment_info[coupon_code]", with: flat_coupon.code)
end

Then(/^my subtotal should be discounted by a flat amount$/) do
  sleep 1
  order = Order.last
  cart = Cart.last
  flat_coupon = FlatCoupon.last
  expect(order.subtotal).to eq(cart.total)
  expect(order.savings).to eq(Money.new(flat_coupon.value*100))
  expect(page).to have_content("Savings")
  expect(page).to have_content(order.savings)
end

When(/^I fill in the form to sign up at the checkout page$/) do
  click_link("Sign up")
  fill_in("user[email]", with: "abc123@yahoo.com")
  fill_in("user[password]", with: "test123")
end



When(/^I enter a valid percentage coupon code$/) do
  percentage_coupon = PercentageCoupon.last
  fill_in("payment_info[coupon_code]", with: percentage_coupon.code)
end

Then(/^my subtotal should be discounted by a percentage amount$/) do
  sleep 1
  order = Order.last
  cart = Cart.last
  percentage_coupon = PercentageCoupon.last
  expect(order.subtotal).to eq(cart.total)
  expect(order.savings).to eq(cart.total * percentage_coupon.value / 100 )
  expect(page).to have_content("Savings")
  expect(page).to have_content(order.savings)
end

Given(/^an existing expired coupon that has a high minimum purchase amount$/) do
  FactoryGirl.create(:free_shipping_coupon, end_date: Date.yesterday, minimum_purchase_amount: 9999.99)
end

When(/^I enter the bad coupon's code$/) do
  free_shipping_coupon = FreeShippingCoupon.last
  fill_in("payment_info[coupon_code]", with: free_shipping_coupon.code)
end

Then(/^I should see errors pertaining the coupon I am using$/) do
  expect(page).to have_content("The coupon you entered is expired.")
  expect(page).to have_content("Your order does not meet the minimum purchase amount for this coupon.")
end

When(/^I enter gibberish into the coupon code field$/) do
  fill_in("payment_info[coupon_code]", with: "kjjksjksak")
end

Then(/^I should be prompted to fill in a real coupon code$/) do
  expect(page).to have_content("Please enter a valid coupon code.")
end

Then(/^the coupon code field should automatically be filled in with the coupon's code$/) do
  site_wide_coupon = Coupon.where(site_wide: true).last
  expect(page).to have_field("payment_info[coupon_code]", with: site_wide_coupon.code)
end

Then(/^the coupon code field should not be filled in$/) do
  expect(page).to have_field("payment_info[coupon_code]", with: "")
end

Then(/^I should be on the checkout page$/) do
  expect(current_path).to eq(billing_checkout_path)
end

When(/^I fill in the form to sign up at the checkout page with an invalid email$/) do
  click_link("Sign up")
  click_button("Sign up")
end

Then(/^I should see sign up errors$/) do
  expect(page).to have_content("Email can't be blank")
  expect(page).to have_content("Email is invalid")
end

When(/^I fill in the form to log in at the checkout page with an invalid password$/) do
  within(".user_info") do
    click_link("Log in")
  end
  click_button("Log in")
end

Then(/^I should see sign in errors$/) do
  expect(page).to have_content("The email and password you entered are incorrect. Please try again.")
end

Then(/^my shipping address should be prefilled$/) do
  order = Order.in_progress_or_shipped.last
  shipping_address = order.shipping_address
  expect(page).to have_field("payment_info[shipping_address_first_name]", with: shipping_address.first_name)
  expect(page).to have_field("payment_info[shipping_address_last_name]", with: shipping_address.last_name)
  expect(page).to have_field("payment_info[shipping_address_street_address]", with: shipping_address.street_address)
  expect(page).to have_field("payment_info[shipping_address_street_address2]", with: shipping_address.street_address2)
  expect(page).to have_field("payment_info[shipping_address_city]", with: shipping_address.city)
  expect(page).to have_select("payment_info[shipping_address_state_id]", selected: shipping_address.state.short_name)
  expect(page).to have_field("payment_info[shipping_address_zip_code]", with: shipping_address.zip_code)
  expect(page).to have_field("payment_info[shipping_address_phone_number]", with: shipping_address.phone_number)
end

Then(/^my billing address should be prefilled$/) do
  order = Order.in_progress_or_shipped.last
  billing_address = order.billing_address
  expect(page).to have_field("payment_info[billing_address_first_name]", with: billing_address.first_name)
  expect(page).to have_field("payment_info[billing_address_last_name]", with: billing_address.last_name)
  expect(page).to have_field("payment_info[billing_address_street_address]", with: billing_address.street_address)
  expect(page).to have_field("payment_info[billing_address_street_address2]", with: billing_address.street_address2)
  expect(page).to have_field("payment_info[billing_address_city]", with: billing_address.city)
  expect(page).to have_select("payment_info[billing_address_state_id]", selected: billing_address.state.short_name)
  expect(page).to have_field("payment_info[billing_address_zip_code]", with: billing_address.zip_code)
  expect(page).to have_field("payment_info[billing_address_phone_number]", with: billing_address.phone_number)
end

When(/^I click the same as shipping address checkbox$/) do
  check("Same as shipping address")
end

Then(/^my billing address should be automatically filled$/) do
  expect(page).to have_field("payment_info[billing_address_first_name]", with: "Lorem")
  expect(page).to have_field("payment_info[billing_address_last_name]", with: "Ipsum")
  expect(page).to have_field("payment_info[billing_address_street_address]", with: "123 Fake Street")
  expect(page).to have_field("payment_info[billing_address_street_address2]", with: "12")
  expect(page).to have_field("payment_info[billing_address_city]", with: "New York")
  expect(page).to have_select("payment_info[billing_address_state_id]", selected: State.new_york.short_name)
  expect(page).to have_field("payment_info[billing_address_zip_code]", with: Tax.last.zip_code)
  expect(page).to have_field("payment_info[billing_address_phone_number]", with: "1231231234")
end
