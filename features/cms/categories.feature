Feature: Categorys

	Background:
		Given I am an authenticated admin user
		
		
	Scenario: Creating a new category
		When I visit the admin categories new page
		And I fill in the form to create a new category
		And I press "Create Category"
		Then my category should be created
		
	Scenario: Index page
		Given existing categories
		When I visit the admin categories index page
		Then I should see a list of categories

	Scenario: Editing a category
		Given an existing category
		When I visit the admin categories edit page 
		And I edit my category
		And I press "Update Category"
		Then my category should be updated
		
	Scenario: Deleting a category
		Given an existing category
		When I visit the admin categories edit page
		And I click "Delete Category"
		Then my category should be deleted