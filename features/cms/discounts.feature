Feature: Discounts
	
	Background:
		Given I am an authenticated admin user
	
	@javascript
	Scenario: Applying discounts to products
		Given an existing complete product
		When I visit the admin discounts page
		And I add the last product color to the discount list
		And I apply a 20 percent discount
		Then that product should now have a 20 percent discounted price
		
	@javascript
	Scenario: Applying discounts to collections
		Given an existing collection with a complete product associated with it
		When I visit the admin discounts page
		And I add the last collection to the discount list
		And I apply a 10 percent discount
		Then that collection's products should now have a 10 percent discounted price
		
	@javascript
	Scenario: Removing discounts from products
		Given an existing complete product
		When I visit the admin discounts page
		And I add the last product color to the discount list
		And I remove all discounts
		Then that product should now have no discounts
		
	@javascript
	Scenario: Removing discounts from collections
		Given an existing collection with a complete product associated with it
		When I visit the admin discounts page
		And I add the last collection to the discount list
		And I remove all discounts
		Then that collection's products should now have no discounts
	