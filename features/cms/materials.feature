Feature: Materials

	Background:
		Given I am an authenticated admin user
		
		
	Scenario: Creating a new material
		When I visit the admin materials new page
		And I fill in the form to create a new material
		And I press "Create Material"
		Then my material should be created
		
	Scenario: Index page
		Given existing materials
		When I visit the admin materials index page
		Then I should see a list of materials

	Scenario: Editing a material
		Given an existing material
		When I visit the admin materials edit page 
		And I edit my material
		And I press "Update Material"
		Then my material should be updated
		
	Scenario: Deleting a material
		Given an existing material
		When I visit the admin materials edit page
		And I click "Delete Material"
		Then my material should be deleted