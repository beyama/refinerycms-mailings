@mailings
Feature: Mailings
  In order to have mailings on my website
  As an administrator
  I want to manage mailings

  Background:
    Given I am a logged in refinery user
    And I have no mailings
    And I have a default sender

  @mailings-list @list
  Scenario: Mailings List
   Given I have mailings titled TitleOne, TitleTwo
   When I go to the list of mailings
   Then I should see "TitleOne"
   And I should see "TitleTwo"

  @mailings-valid @valid
  Scenario: Create Valid Mailing
    Given I only have newsletters titled News
    When I go to the list of mailings
    And I follow "Create new mailing"
    And I check "News"
    And I fill in "Subject" with "This is my subject"
    And I fill in "mailing_body" with "This is plain text"
    And I fill in "mailing_html_body" with "<h1>This is html text</h1>"
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
    Given I only have mailings titled TitleOne
    When I go to the list of mailings
    And I follow "Remove this mailing forever"
    Then I should see "'TitleOne' was successfully removed."
    And I should have 0 mailings

  @mailings-send-test-mail
  Scenario: Send a test mail
    Given I only have mailings titled TitleOne
    And I only have public newsletters titled News
    And I have subscribers with email addresses one@example.org, two@example.org
    And I have no mails
    When I go to the list of mailings
    And I follow "Edit this mailing" within ".actions"
    And I check "News"
    And I press "Send test mail"
    Then I should have 1 mails


  @mailings-send-mailing
  Scenario: Send a test mail
    Given I only have mailings titled TitleOne
    And I only have public newsletters titled News
    And I have subscribers with email addresses one@example.org, two@example.org
    And I have no mails
    When I go to the list of mailings
    And I follow "Edit this mailing" within ".actions"
    And I check "News"
    And I press "Send mailing"
    And after running the mailing job
    Then I should have 2 mails