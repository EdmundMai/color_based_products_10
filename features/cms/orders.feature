Feature: Orders CMS

	Background:
		Given I am an authenticated admin user

	Scenario: Orders index
		Given existing orders in progress
		And existing shipped orders
		And existing incomplete orders
		When I visit the admin orders index page
		Then I should see a list of orders that are shipped or in progress
		And I should not see any incomplete orders
	
	Scenario: Viewing an order
		Given existing orders in progress
		When I visit the admin order show page
		Then I should see all of my order's information
		
	Scenario: Updating the status of an order
		Given existing orders in progress
		When I visit the admin order show page
    And I fill in the tracking number
		And I update the order status to "Shipped"
		Then that order's status should be marked as "Shipped"
    And that order should have a tracking number
    
  Scenario: Canceling an order
		Given existing orders in progress
		When I visit the admin order show page
		And I update the order status to "Cancelled"
    Then that order's status should be marked as "Cancelled"
	
	Scenario: Exporting orders to a CSV file
		Given existing orders in progress
		And existing shipped orders 
		When I visit the admin orders index page
		And I export my orders into a CSV file
		Then I should receive a CSV file