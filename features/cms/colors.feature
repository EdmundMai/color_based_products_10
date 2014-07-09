Feature: Colors

	Background:
		Given I am an authenticated admin user

	Scenario: Creating a color
		When I visit the admin color new page
		And I fill out the form to create a color
		And I press "Create Color"
		Then my color should be created
		
	Scenario: Index page
		Given existing colors
		When I visit the admin color index page
		Then I should see a list of colors
		
	@javascript
	Scenario: Editing a color
		Given an existing color
		When I visit the admin color edit page
		And I edit the color
		And I press "Update Color"
		Then my color should be updated
		
	Scenario: Deleting a color
		Given an existing color
		When I visit the admin color edit page
		And I click "Delete Color"
		Then my color should be deleted