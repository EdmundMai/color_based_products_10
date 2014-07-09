Feature: Account settings

	Scenario: Viewing my account settings without logging in
		When I visit my account settings
		Then I should be redirected to the sign in page

	Scenario: Viewing my account settings
		Given I am an authenticated customer
		When I visit my account settings
		Then I should see my account settings
		
	Scenario: Editing my email and password without logging in
		When I visit the users edit page
		Then I should be redirected to the sign in page

	Scenario: Editing my email and password
		Given I am an authenticated customer
		When I visit my account settings
		And I click "Edit Account"
		And I change my email and password
		And I press "Update"
		Then my account should be updated
		
	Scenario: Viewing my order history without logging in
		When I visit the orders index page
		Then I should be redirected to the sign in page
		
	Scenario: Viewing my order history
		Given I am an authenticated customer
		And existing past orders
		And existing past returns
		When I visit my account settings
		And I click "Order History"
		Then I should see a list of my past orders
		And I should see a list of my past returns
		
	Scenario: Viewing an individual past order
		Given I am an authenticated customer
		And existing past orders
		When I visit my account settings
		And I click "Order History"
		And I click on my last past order
		Then I should see all of my order's information
		
	Scenario: Viewing an order placed over 30 days ago
		Given I am an authenticated customer
		And an existing past order placed 2 months ago
		When I visit my account settings
		And I click "Order History"
		And I click on my last past order
		Then I should not see a link for creating a return
	
	@javascript
	Scenario: Placing a return
		Given I am an authenticated customer
		And existing past orders
		When I visit my account settings
		And I click "Order History"
		And I click on my last past order
		And I click "Return items from this order"
		And I fill out the form to create a return
		And I press "Create Return"
		Then my return should be placed
		And I should be on the return show page
		When I click "View Return Slip"
		Then I should see a return invoice slip
		
	Scenario: Viewing an individual past return without logging in
		Given existing returns
		When I view a return
		Then I should be redirected to the sign in page
		
	Scenario: Viewing an individual past return
		Given I am an authenticated customer
		And existing past returns
		When I visit my account settings
		And I click "Order History"
		And I click on my last past return
		Then I should see all of my return's information
		
	Scenario: Viewing an order with no more returnable items
		Given I am an authenticated customer
		And an existing past order with no more returnable items
		When I visit my account settings
		And I click "Order History"
		And I click on my last past order
		Then I should not see a link for creating a return