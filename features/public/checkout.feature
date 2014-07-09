Feature: Checkout

	Scenario: Adding a product to my cart
		Given an existing active product with instock variants
		When I visit the product show page
		And I add that product to my cart
		Then my cart should have one item
		And I should be on the shopping cart page
		
	Scenario: Adding the same variant to my cart multiple times
		Given an existing active product with instock variants
		When I visit the product show page
		And I add that product to my cart
		And I visit the product show page
		And I add that product to my cart
		Then my cart should have one item
		And the quantity of my cart item should be 2
		
	Scenario: Removing a product from my cart
		Given an existing item in my cart
		When I visit the shopping cart page
		And I remove an item from my cart
		Then my cart should have no items
		And I should see a "Continue Shopping" link
		
	@javascript
	Scenario: Form errors on Review
		Given an existing state
		Given an existing New York state
		And an existing tax for zip code "10001"
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in the form to sign up at the checkout page
		And I press "Sign up"
		And I fill in a invalid shipping address
		And I fill in a invalid billing address
		And I fill in a invalid credit card
		And I press "Review"
		Then I should see errors for my payment info
		And the review button should be enabled
		And the submit order button should be disabled
		And the edit payment info button should be disabled
		
	@javascript
	Scenario: Editing info after review
		Given an existing state
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I press "Review"
		And I press "Edit Payment Info"
		Then the review button should be enabled
		And the submit order button should be disabled
		
	@javascript
	Scenario: Signing up on the checkout page - Unhappy path
		Given an existing state
		Given an existing New York state
		And an existing tax for zip code "10001"
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in the form to sign up at the checkout page with an invalid email
		And I press "Sign up"
		Then I should see sign up errors
	
	
	@javascript
	Scenario: Logging in on the checkout page - Unhappy path
		Given an existing state
		Given an existing New York state
		And an existing tax for zip code "10001"
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in the form to log in at the checkout page with an invalid password
		And I press "Log in"
		Then I should see sign in errors	
		
	@javascript
	Scenario: Signing up on the checkout page - Happy path
		Given an existing state
		Given an existing New York state
		And an existing tax for zip code "10001"
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		Then the review button should be disabled
		And the submit order button should be disabled
		And the edit payment info button should be disabled
		And I fill in the form to sign up at the checkout page
		And I press "Sign up"
		Then my permanent user cart should have one item
		And I should be on the checkout page
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I press "Review"
		And I submit my order
		Then my order should be placed
		And my user should be updated
		And I should receive an order confirmation email
		And my guest cookie should be deleted
		
	@javascript
	Scenario: Logging in on the checkout page - Happy path
		Given an existing state
		And an existing New York state
		And an existing user
		And an existing tax for zip code "10001"
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in the form to log in at the checkout page
		And I press "Log in"
		Then my permanent user cart should have one item
		And I should be on the checkout page
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I press "Review"
		And I submit my order
		Then my order should be placed
		And my permanent user cart should be empty
		And I should receive an order confirmation email
		And my guest cookie should be deleted
		
	@javascript
	Scenario: Checking out as a logged in user - Happy path
		Given an existing state
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		Then the review button should be enabled
		And the submit order button should be disabled
		When I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I press "Review"
		And I submit my order
		Then my order should be placed
    
  Scenario: The user has past orders
		Given an existing state
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
    And existing past orders
    And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
    Then my shipping address should be prefilled
    Then my billing address should be prefilled
	
	@javascript
	Scenario: Using a free shipping coupon
		Given an existing state
		And an existing free shipping coupon
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I enter a valid free shipping coupon code
		And I press "Review"
		Then my shipping should be set to zero
		
	@javascript
	Scenario: Using a flat coupon
		Given an existing state
		And an existing flat coupon
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I enter a valid flat coupon code
		And I press "Review"
		Then my subtotal should be discounted by a flat amount
		
	@javascript
	Scenario: Using a percentage coupon
		Given an existing state
		And an existing percentage coupon
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I enter a valid percentage coupon code
		And I press "Review"
		Then my subtotal should be discounted by a percentage amount
		
	@javascript
	Scenario: Entering a bad coupon
		Given an existing state
		And an existing expired coupon that has a high minimum purchase amount
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I enter the bad coupon's code
		And I press "Review"
		Then I should see errors pertaining the coupon I am using
		And the review button should be enabled
		And the submit order button should be disabled
		And the edit payment info button should be disabled
		
	@javascript
	Scenario: Entering gibberish in the coupon field
		Given an existing state
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I enter gibberish into the coupon code field
		And I press "Review"
		Then I should be prompted to fill in a real coupon code
		And the review button should be enabled
		And the submit order button should be disabled
		And the edit payment info button should be disabled
		
	Scenario: The order qualifies for a site wide coupon
		Given an existing state
		And an existing site wide flat coupon
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		Then the coupon code field should automatically be filled in with the coupon's code
	
	@javascript
	Scenario: The order does not qualify for a site wide coupon
		Given an existing state
		And an existing site wide flat coupon with an enormous minimum purchase amount
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		Then the coupon code field should not be filled in
    
  @javascript
  Scenario: Checking the 'Billing address is same as shipping address' checkbox
		Given an existing state
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in a valid shipping address
    And I click the same as shipping address checkbox
    Then my billing address should be automatically filled