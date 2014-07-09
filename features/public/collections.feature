Feature: Collections

	Scenario: Viewing a collection
		Given an existing collection with a product associated with it
		When I view that collection
		Then I should see that collection's information