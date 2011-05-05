@subscribers
Feature: Subscribers
  In order to have subscribers on my website
  As an administrator
  I want to manage subscribers

  Background:
    Given I am a logged in refinery user
    And I only have public newsletters titled 'news'
    And I have no subscribers

  @subscribers-list @list
  Scenario: Subscribers List
   Given I have subscribers with email addresses one@example.org, two@example.org
   When I go to the list of subscribers
   Then I should see "one@example.org"
   And I should see "two@example.org"

#  @subscribers-valid @valid
#  Scenario: Create Valid Subscriber
#    When I go to the list of subscribers
#    And I follow "Add New Subscriber"
#    And I fill in "Email" with "This is a test of the first string field"
#    And I press "Save"
#    Then I should see "'This is a test of the first string field' was successfully added."
#    And I should have 1 subscriber

#  @subscribers-invalid @invalid
#  Scenario: Create Invalid Subscriber (without email)
#    When I go to the list of subscribers
#    And I follow "Add New Subscriber"
#    And I press "Save"
#    Then I should see "Email can't be blank"
#    And I should have 0 subscribers

  @subscribers-edit @edit
  Scenario: Edit Existing Subscriber
    Given I have subscribers with email addresses one@example.org
    When I go to the list of subscribers
    And I follow "Edit this subscriber" within ".actions"
    Then I check "news"
    And I press "Update"

#  @subscribers-duplicate @duplicate
#  Scenario: Create Duplicate Subscriber
#    Given I have subscribers with email addresses one@example.org, two@example.org
#    When I go to the list of subscribers
#    And I follow "Add New Subscriber"
#    And I fill in "Email" with "UniqueTitleTwo"
#    And I press "Save"
#    Then I should see "There were problems"
#    And I should have 2 subscribers

  @subscribers-delete @delete
  Scenario: Delete Subscriber
    Given I have subscribers with email addresses one@example.org
    When I go to the list of subscribers
    And I follow "Remove this subscriber forever"
    Then I should see "'one@example.org' was successfully removed."
    And I should have 0 subscribers
 