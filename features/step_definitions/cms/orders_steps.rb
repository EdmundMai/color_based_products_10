Given(/^existing orders in progress$/) do
  FactoryGirl.create(:in_progress_order, total_cents: 1234, order_date: 1.day.ago)
end

Given(/^existing shipped orders$/) do
  FactoryGirl.create(:shipped_order, total_cents: 3333, order_date: 1.week.ago)
end

Given(/^existing incomplete orders$/) do
  FactoryGirl.create(:order, status: Order::INCOMPLETE, total_cents: 6666)
end

When(/^I visit the admin orders index page$/) do
  visit admin_orders_path
end

Then(/^I should see a list of orders that are shipped or in progress$/) do
  shipped_purchase = Order.where(status: Order::SHIPPED).last
  in_progress_purchase = Order.where(status: Order::IN_PROGRESS).last
  expect(page).to have_content("$#{shipped_purchase.total}")
  expect(page).to have_content("$#{in_progress_purchase.total}")
  expect(page).to have_content(shipped_purchase.status)
  expect(page).to have_content(shipped_purchase.billing_address.full_name)
  expect(page).to have_content(in_progress_purchase.status)
  expect(page).to have_content(in_progress_purchase.billing_address.full_name)
  expect(page).to have_content(shipped_purchase.order_date.strftime("%m/%d/%Y"))  
  expect(page).to have_content(in_progress_purchase.order_date.strftime("%m/%d/%Y"))  
end

Then(/^I should not see any incomplete orders$/) do
  incomplete_purchase = Order.where(status: Order::INCOMPLETE).last
  expect(page).not_to have_content("$#{incomplete_purchase.total}")  
  expect(page).not_to have_content(incomplete_purchase.status)
end

When(/^I visit the admin order show page$/) do
  order = Order.last
  visit admin_order_path(order)
end

Then(/^I should see all of my order's information$/) do
  order = Order.last
  expect(page).to have_content(order.user.email)
  expect(page).to have_content(order.order_date.strftime("%m/%d/%Y"))
  expect(page).to have_content("$#{order.total}")
  expect(page).to have_content("$#{order.tax}")
  expect(page).to have_content("$#{order.shipping}")
  expect(page).to have_content("$#{order.subtotal}")
  expect(page).to have_content(order.shipping_address.first_name)
  expect(page).to have_content(order.shipping_address.last_name)
  expect(page).to have_content(order.shipping_address.street_address)
  expect(page).to have_content(order.shipping_address.street_address2)
  expect(page).to have_content(order.shipping_address.city)
  expect(page).to have_content(order.shipping_address.state.short_name)
  expect(page).to have_content(order.shipping_address.zip_code)
  expect(page).to have_content(order.shipping_address.phone_number)
  expect(page).to have_content(order.billing_address.first_name)
  expect(page).to have_content(order.billing_address.last_name)
  expect(page).to have_content(order.billing_address.street_address)
  expect(page).to have_content(order.billing_address.street_address2)
  expect(page).to have_content(order.billing_address.city)
  expect(page).to have_content(order.billing_address.state.short_name)
  expect(page).to have_content(order.billing_address.zip_code)
  expect(page).to have_content(order.billing_address.phone_number)
  
  expect(order.line_items.count).not_to be == 0
  order.line_items.each do |line_item|
    expect(page).to have_content(line_item.variant.size.name)
    expect(page).to have_content(line_item.variant.sku)
    expect(page).to have_content(line_item.variant.product.name)
    expect(page).to have_content(line_item.variant.products_color.color.name)
    expect(page).to have_content(line_item.quantity)
    expect(page).to have_content("$#{line_item.unit_price}")
  end
end

When(/^I update the order status to "(.*?)"$/) do |order_status|
  select(order_status, from: "order[status]")
  click_button("Update")
end


When(/^I fill in the tracking number$/) do
  fill_in("order[tracking_number]", with: "123123123")
end

Then(/^that order should have a tracking number$/) do
  order = Order.last
  expect(order.tracking_number).to eq("123123123")
end


Then(/^that order's status should be marked as "(.*?)"$/) do |order_status|
  order = Order.last
  expect(order.status).to eq(order_status)
  expect(page).to have_content("Order ##{order.id} has been updated.")
end

When(/^I export my orders into a CSV file$/) do
  fill_in("from_date", with: Date.yesterday.strftime("%m/%d/%Y"))
  fill_in("to_date", with: Date.tomorrow.strftime("%m/%d/%Y"))
  
  click_button("Download Report")
end

Then(/^I should receive a CSV file$/) do
  page.response_headers['Content-Disposition'].should include("orders_report_from_#{Date.yesterday}_to_#{Date.tomorrow}.csv")
end