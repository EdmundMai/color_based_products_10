Feature: Collections

	Background:
		Given I am an authenticated admin user

	Scenario: Creating a new collection
		When I visit the admin collections new page
		And I fill in the form to create a new collection
		And I press "Create Collection"
		Then my collection should be created
		
	Scenario: Index page
		Given existing collections
		When I visit the admin collections index page
		Then I should see a list of collections
		
	Scenario: Editing a collection
		Given existing collections
		When I visit the admin collections edit page
		And I edit the collection
		And I make the collection active
		And I press "Update Collection"
		Then my collection should be updated
		
	Scenario: Deleting a collection
		Given an existing collection
		When I visit the admin collections edit page
		And I click "Delete Collection"
		Then my collection should be deleted
		
	@javascript
	Scenario: Adding products to a collection
		Given existing collections
		And existing products
		When I visit the admin collections edit page
		And I add a product to my collection
		Then my collection should have a product
		And that product should not be on the available products list
		And that product should be on the chosen products list
		
	@javascript
	Scenario: Remove products from a collection
		Given an existing collection with a product associated with it
		When I visit the admin collections edit page
		And I remove a product from my collection
		Then my collection should have no products
		And that product should be on the available products list
		And that product should not be on the chosen products list
	
	@javascript
	Scenario: Searching for a product
		Given an existing collection with a product associated with it
		And existing products
		When I visit the admin collections edit page
		And I search for an available product's name
		Then that product should be on the available products list
		When I search for a product that already exists in my chosen products
		Then there should be no available products results
		When I reset my product search
		Then the available products list should be reset