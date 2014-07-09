Feature: Returns CMS

	Background:
		Given I am an authenticated admin user

	Scenario: Index page
		Given existing returns
		When I visit the admin returns index page
		Then I should see a list of returns information
		
	Scenario: Viewing a return
		Given existing returns
		When I visit the admin return show page
		Then I should see my return's information

	Scenario: Updating a return
		Given existing returns
		When I visit the admin return show page
		And I update the status, amount, and admin comments of the return
		And I press "Update"
		Then my return should be updated
		
	Scenario: Searching for a return using the RMA code
		Given an existing return with an RMA code of "ABC123"
		When I visit the admin returns index page
		And I search for the RMA code "ABC123"
		And I press "Search"
		Then I should see a return result