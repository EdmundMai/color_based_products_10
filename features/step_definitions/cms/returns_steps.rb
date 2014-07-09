Given(/^existing returns$/) do
  FactoryGirl.create_list(:return, 2)
end

When(/^I visit the admin returns index page$/) do
  visit admin_returns_path
end

Then(/^I should see a list of returns information$/) do
  expect(Return.count).to be > 0
  Return.all.each do |r|
    expect(page).to have_content(r.id)
    expect(page).to have_content(r.status)
  end
end

When(/^I visit the admin return show page$/) do
  last_return = Return.last
  visit admin_return_path(last_return)
end

When(/^I update the status, amount, and admin comments of the return$/) do
  fill_in("return[amount]", with: "11.22")
  select(Return::RECEIVED, from: "return[status]")
  fill_in("return[admin_comment]", with: "Only half price was returned")
end

Then(/^my return should be updated$/) do
  last_return = Return.last
  expect(last_return.amount).to eq(11.22)
  expect(last_return.status).to eq(Return::RECEIVED)
  expect(last_return.admin_comment).to eq("Only half price was returned")
end

Given(/^an existing return with an RMA code of "(.*?)"$/) do |rma_code|
  FactoryGirl.create(:return, rma_code: rma_code)
end

When(/^I search for the RMA code "(.*?)"$/) do |arg1|
  fill_in("q[rma_code_cont]", with: Return.last.rma_code)
end

Then(/^I should see my return's information$/) do
  last_return = Return.last
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

Then(/^I should see a return result$/) do
  last_return = Return.last
  expect(page).to have_content(last_return.id)
  expect(page).to have_content(last_return.amount)
  expect(page).to have_content(last_return.rma_code)
  expect(page).to have_content(last_return.status)
end