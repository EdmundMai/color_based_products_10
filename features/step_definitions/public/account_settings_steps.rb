When(/^I visit my account settings$/) do
  visit account_path
end

Then(/^I should see my account settings$/) do
  expect(page).to have_content("Account Settings")
  expect(page).to have_content("Edit Account")
  expect(page).to have_content("Order History")
end

Then(/^I should be redirected to the sign in page$/) do
  expect(current_path).to eq(new_user_session_path)
end

When(/^I change my email and password$/) do
  fill_in("user[email]", with: "mynewemail@email.com")
  fill_in("user[password]", with: "mynewpassword")
  fill_in("user[password_confirmation]", with: "mynewpassword")
  fill_in("user[current_password]", with: "test123")
end

Then(/^my account should be updated$/) do
  user = User.last
  expect(user.email).to eq("mynewemail@email.com")
end

Given(/^existing past orders$/) do
  user = User.last
  user.orders << FactoryGirl.create(:shipped_order, user: user)
end

Then(/^I should see a list of my past orders$/) do
  user = User.last
  expect(user.past_orders.count).to be > 0
  user.past_orders.each do |order|
    expect(page).to have_content(order.id)
    expect(page).to have_content(order.order_date.strftime("%m/%d/%Y"))
    expect(page).to have_content(order.total)
  end
end

When(/^I visit the users edit page$/) do
  visit edit_user_registration_path
end

When(/^I visit the orders index page$/) do
  visit orders_path
end

When(/^I click on my last past order$/) do
  user = User.last
  click_link(user.last_complete_order.id.to_s)
end

When(/^I fill out the form to create a return$/) do
  user = User.last
  last_order = user.last_complete_order
  last_line_item = last_order.line_items.last
  check("return[return_items_attributes][0][chosen]")
  select("1", from: "return[return_items_attributes][0][quantity]")
  
  select("Item is damaged", from: "return[reason]")
end

Then(/^my return should be placed$/) do
  user = User.last
  last_order = user.last_complete_order
  
  expect(Return.count).to be == 1
  
  last_return = Return.last
  expect(last_return.order).to eq(last_order)
  expect(last_return.user).to eq(user)
  expect(last_return.status).to eq(Return::PROCESSING)
  expect(last_return.reason).to eq("Item is damaged")
  expect(last_return.rma_code).not_to be_blank
  
  last_return_item = last_return.return_items.last
  expect(last_return_item.quantity).to eq(1)
  expect(last_return_item.line_item).to eq(last_order.line_items.last)
  
end


When(/^I view a return$/) do
  last_return = Return.last
  visit order_return_path(last_return.order, last_return)
end


Given(/^existing past returns$/) do
  user = User.last
  order = FactoryGirl.create(:order, user: user)
  user.returns << FactoryGirl.create(:return, user: user, order_id: order.id)
end

Then(/^I should see a list of my past returns$/) do
  user = User.last
  expect(user.returns.count).to be > 0
  user.returns.each do |r|
    expect(page).to have_content(r.created_at.strftime("%m/%d/%Y"))
    expect(page).to have_content(r.amount)
  end
end

When(/^I click on my last past return$/) do
  user = User.last
  last_return = user.returns.last 
  click_link(last_return.id)
end

Then(/^I should see all of my return's information$/) do
  user = User.last
  last_return = user.returns.last 
  expect(page).to have_content(last_return.amount)
  expect(page).to have_content(last_return.status)
  expect(page).to have_content(last_return.admin_comment)
  expect(page).to have_content(last_return.rma_code)
  expect(page).to have_content(last_return.reason)
  
  expect(last_return.return_items.count).to be > 0
  last_return.return_items.each do |return_item|
    expect(page).to have_content(return_item.line_item.variant.product.name)
    expect(page).to have_content(return_item.line_item.variant.size.name)
    expect(page).to have_content(return_item.line_item.variant.color.name)
    expect(page).to have_content(return_item.quantity)
  end

end


Then(/^I should be on the return show page$/) do
  user = User.last
  last_return = user.returns.last 
  expect(current_path).to eq(order_return_path(last_return.order, last_return))
end


Then(/^I should see a return invoice slip$/) do
  user = User.last
  last_return = user.returns.last 
  order = last_return.order
  
  expect(last_return.return_items.count).to be > 0
  
  last_return.return_items.each do |return_item|
    expect(page).to have_content(return_item.line_item.variant.product.name)
    expect(page).to have_content(return_item.line_item.variant.sku)
    expect(page).to have_content(return_item.line_item.unit_price)
    expect(page).to have_content(return_item.line_item.unit_price * return_item.quantity)
  end
  
  expect(page).to have_content(order.shipping_address.full_name)
  expect(page).to have_content(order.shipping_address.street_address)
  expect(page).to have_content(order.shipping_address.street_address2)
  expect(page).to have_content(order.shipping_address.city_state_zipcode)
  expect(page).to have_content(order.shipping_address.phone_number)
  
  expect(page).to have_content(WAREHOUSE_ADDRESS[:name])
  expect(page).to have_content(WAREHOUSE_ADDRESS[:address])
  expect(page).to have_content(WAREHOUSE_ADDRESS[:address2])
  expect(page).to have_content(WAREHOUSE_ADDRESS[:city_state_zipcode])
  expect(page).to have_content(WAREHOUSE_ADDRESS[:phone_number])
end


Given(/^an existing past order with no more returnable items$/) do
  user = User.last
  order = FactoryGirl.create(:shipped_order, user_id: user.id)
  line_item = order.line_items.last
  return_item = FactoryGirl.create(:return_item, line_item_id: line_item.id, quantity: line_item.quantity)
  r = FactoryGirl.create(:return, order_id: order.id, return_items: [return_item])
end

Then(/^I should not see a link for creating a return$/) do
  expect(page).not_to have_link("Return items from this order")
end

Given(/^an existing past order placed (\d+) months ago$/) do |number|
  user = User.last
  user.orders << FactoryGirl.create(:shipped_order, user: user, order_date: number.to_i.months.ago)
end

