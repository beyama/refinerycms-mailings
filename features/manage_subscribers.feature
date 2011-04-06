@subscribers
Feature: Subscribers
  In order to have subscribers on my website
  As an administrator
  I want to manage subscribers

  Background:
    Given I am a logged in refinery user
    And I have no subscribers

  @subscribers-list @list
  Scenario: Subscribers List
   Given I have subscribers titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of subscribers
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @subscribers-valid @valid
  Scenario: Create Valid Subscriber
    When I go to the list of subscribers
    And I follow "Add New Subscriber"
    And I fill in "Email" with "This is a test of the first string field"
    And I press "Save"
    Then I should see "'This is a test of the first string field' was successfully added."
    And I should have 1 subscriber

  @subscribers-invalid @invalid
  Scenario: Create Invalid Subscriber (without email)
    When I go to the list of subscribers
    And I follow "Add New Subscriber"
    And I press "Save"
    Then I should see "Email can't be blank"
    And I should have 0 subscribers

  @subscribers-edit @edit
  Scenario: Edit Existing Subscriber
    Given I have subscribers titled "A email"
    When I go to the list of subscribers
    And I follow "Edit this subscriber" within ".actions"
    Then I fill in "Email" with "A different email"
    And I press "Save"
    Then I should see "'A different email' was successfully updated."
    And I should be on the list of subscribers
    And I should not see "A email"

  @subscribers-duplicate @duplicate
  Scenario: Create Duplicate Subscriber
    Given I only have subscribers titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of subscribers
    And I follow "Add New Subscriber"
    And I fill in "Email" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 subscribers

  @subscribers-delete @delete
  Scenario: Delete Subscriber
    Given I only have subscribers titled UniqueTitleOne
    When I go to the list of subscribers
    And I follow "Remove this subscriber forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 subscribers
 