@mailings
Feature: Mailings
  In order to have mailings on my website
  As an administrator
  I want to manage mailings

  Background:
    Given I am a logged in refinery user
    And I have no mailings

  @mailings-list @list
  Scenario: Mailings List
   Given I have mailings titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of mailings
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @mailings-valid @valid
  Scenario: Create Valid Mailing
    When I go to the list of mailings
    And I follow "Create new mailing"
    And I fill in "Subject" with "This is my subject"
    And I press "Save"
    Then I should see "'This is my subject' was successfully added."
    And I should have 1 mailing

  @mailings-invalid @invalid
  Scenario: Create Invalid Mailing (without subject)
    When I go to the list of mailings
    And I follow "Create new mailing"
    And I press "Save"
    Then I should see "Subject can't be blank"
    And I should have 0 mailings

  @mailings-edit @edit
  Scenario: Edit Existing Mailing
    Given I have mailings titled "A subject"
    When I go to the list of mailings
    And I follow "Edit this mailing" within ".actions"
    Then I fill in "Subject" with "A different subject"
    And I press "Save"
    Then I should see "'A different subject' was successfully updated."
    And I should be on the list of mailings
    And I should not see "A subject"

  @mailings-delete @delete
  Scenario: Delete Mailing
    Given I only have mailings titled UniqueTitleOne
    When I go to the list of mailings
    And I follow "Remove this mailing forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 mailings