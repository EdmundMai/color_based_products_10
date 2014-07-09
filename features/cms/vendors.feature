Feature: Vendors

	Background:
		Given I am an authenticated admin user
		
		
	Scenario: Creating a new vendor
		When I visit the admin vendors new page
		And I fill in the form to create a new vendor
		And I press "Create Vendor"
		Then my vendor should be created
		
	Scenario: Index page
		Given existing vendors
		When I visit the admin vendors index page
		Then I should see a list of vendors

	Scenario: Editing a vendor
		Given an existing vendor
		When I visit the admin vendors edit page 
		And I edit my vendor
		And I press "Update Vendor"
		Then my vendor should be updated
		
	Scenario: Deleting a vendor
		Given an existing vendor
		When I visit the admin vendors edit page
		And I click "Delete Vendor"
		Then my vendor should be deleted