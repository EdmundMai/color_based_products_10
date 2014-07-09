Feature: Coupons

	Background:
		Given I am an authenticated admin user

	Scenario: Index page
		Given existing coupons
		When I visit the admin coupons index page
		Then I should see a list of coupons information
	
	@javascript
	Scenario: Creating a new free shipping coupon
		When I visit the admin coupons new page
		And I fill in the form to create a new free shipping coupon
		And I press "Create Coupon"
		Then my free shipping coupon should be saved
		
	@javascript
	Scenario: Creating a new percentage coupon
		When I visit the admin coupons new page
		And I fill in the form to create a new percentage coupon
		And I press "Create Coupon"
		Then my percentage coupon should be saved
		
	@javascript
	Scenario: Creating a new flat coupon
		When I visit the admin coupons new page
		And I fill in the form to create a new flat coupon
		And I press "Create Coupon"
		Then my flat coupon should be saved
	
	@javascript
	Scenario: Editing a coupon
		Given existing coupons
		When I visit the admin coupons edit page
		And I change the coupon's attributes
		And I press "Update Coupon"
		Then my coupon should be updated
	
	Scenario: Deleting a coupon
		Given an existing flat coupon
		When I visit the admin coupons edit page
		And I click "Delete Coupon"
		Then my coupon should be deleted
	
	Scenario: Creating an invalid coupon
		When I visit the admin coupons new page
		And I press "Create Coupon"
		Then my coupon should not be created
		And I should still see the new coupon form
		