Feature: Shapes

	Background:
		Given I am an authenticated admin user
		
		
	Scenario: Creating a new shape
		When I visit the admin shapes new page
		And I fill in the form to create a new shape
		And I press "Create Shape"
		Then my shape should be created
		
	Scenario: Index page
		Given existing shapes
		When I visit the admin shapes index page
		Then I should see a list of shapes

	Scenario: Editing a shape
		Given an existing shape
		When I visit the admin shapes edit page 
		And I edit my shape
		And I press "Update Shape"
		Then my shape should be updated
		
	Scenario: Deleting a shape
		Given an existing shape
		When I visit the admin shapes edit page
		And I click "Delete Shape"
		Then my shape should be deleted