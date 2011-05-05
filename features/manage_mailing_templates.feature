@mailing_templates
Feature: Mailing Templates
  In order to have mailing_templates on my website
  As an administrator
  I want to manage mailing_templates

  Background:
    Given I am a logged in refinery user
    And I have no mailing_templates

  @mailing_templates-list @list
  Scenario: Mailing Templates List
   Given I have mailing_templates titled newsletter.html, newsletter.text
   When I go to the list of mailing_templates
   Then I should see "newsletter.html"
   And I should see "newsletter.text"

  @mailing_templates-valid @valid
  Scenario: Create Valid Mailing Template
    When I go to the list of mailing_templates
    And I follow "Create new template"
    And I fill in "Name" with "default.html"
    And I press "Save"
    Then I should see "'default.html' was successfully added."
    And I should have 1 mailing_template

  @mailing_templates-invalid @invalid
  Scenario: Create Invalid Mailing Template (without name)
    When I go to the list of mailing_templates
    And I follow "Create new template"
    And I press "Save"
    Then I should see "Name can't be blank"
    And I should have 0 mailing_templates

  @mailing_templates-edit @edit
  Scenario: Edit Existing Mailing Template
    Given I have mailing_templates titled "default.html"
    When I go to the list of mailing_templates
    And I follow "Edit this mailing template" within ".actions"
    Then I fill in "Name" with "newsletter.html"
    And I press "Save"
    Then I should see "'newsletter.html' was successfully updated."
    And I should be on the list of mailing_templates
    And I should not see "default.html"

  @mailing_templates-duplicate @duplicate
  Scenario: Create Duplicate Mailing Template
    Given I only have mailing_templates titled newsletter.html, newsletter.text
    When I go to the list of mailing_templates
    And I follow "Create new template"
    And I fill in "Name" with "newsletter.html"
    And I press "Save"
    Then I should see "There were problems"
    And I should have 2 mailing_templates

  @mailing_templates-delete @delete
  Scenario: Delete Mailing Template
    Given I only have mailing_templates titled newsletter.html
    When I go to the list of mailing_templates
    And I follow "Remove this mailing template forever"
    Then I should see "'newsletter.html' was successfully removed."
    And I should have 0 mailing_templates
 