@newsletters
Feature: Newsletters
  In order to have newsletters on my website
  As an administrator
  I want to manage newsletters

  Background:
    Given I am a logged in refinery user
    And I have no newsletters

  @newsletters-list @list
  Scenario: Newsletters List
   Given I have newsletters titled UniqueTitleOne, UniqueTitleTwo
   When I go to the list of newsletters
   Then I should see "UniqueTitleOne"
   And I should see "UniqueTitleTwo"

  @newsletters-valid @valid
  Scenario: Create Valid Newsletter
    When I go to the list of newsletters
    And I follow "Create new newsletter"
    And I fill in "Name" with "Policy"
    And I press "Save"
    Then I should see "'Policy' was successfully added."
    And I should have 1 newsletter

  @newsletters-invalid @invalid
  Scenario: Create Invalid Newsletter (without name)
    When I go to the list of newsletters
    And I follow "Create new newsletter"
    And I press "Save"
    Then I should see "Name can't be blank"
    And I should have 0 newsletters

  @newsletters-edit @edit
  Scenario: Edit Existing Newsletter
    Given I have newsletters titled "Policy"
    When I go to the list of newsletters
    And I follow "Edit this newsletter" within ".actions"
    Then I fill in "Name" with "Social"
    And I press "Save"
    Then I should see "'Social' was successfully updated."
    And I should be on the list of newsletters
    And I should not see "Policy"

  @newsletters-duplicate @duplicate
  Scenario: Create Duplicate Newsletter
    Given I only have newsletters titled UniqueTitleOne, UniqueTitleTwo
    When I go to the list of newsletters
    And I follow "Create new newsletter"
    And I fill in "Name" with "UniqueTitleTwo"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 newsletters

  @newsletters-delete @delete
  Scenario: Delete Newsletter
    Given I only have newsletters titled UniqueTitleOne
    When I go to the list of newsletters
    And I follow "Remove this newsletter forever"
    Then I should see "'UniqueTitleOne' was successfully removed."
    And I should have 0 newsletters
 