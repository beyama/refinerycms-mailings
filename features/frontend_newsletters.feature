@newsletters-frontend
Feature: Newsletters
  In order to subscribe newsletters
  As an website visitor
  I want to subscribe newsletters

  Background:
    Given I have public newsletters titled Policy, Social
    And I have no subscribers
    And A simple newsletter page exists
    And A Refinery user exists

  @newsletters-frontend-list @list
  Scenario: List Newsletters
    When I go to the frontend list of newsletters
    Then I should see "Policy"
    And I should see "Social"
    
  @newletters-subscribe
  Scenario: Subscribe Newsletters
    When I go to the frontend list of newsletters
    And check newsletters titled Policy, Social
    And I fill in "Email" with "me@example.org"
    And I press "Subscribe"
    And I should be on the frontend list of newsletters
    And I should have a subscription confirm mail
    And I should have 1 subscribers
    
  @newletters-unsubscribe
  Scenario: Unsubscribe Newsletters
    Given I am a subscriber of Policy with email address me@example.org
    When I go to the frontend list of newsletters
    And check newsletters titled Policy
    And I fill in "Email" with "me@example.org"
    And I press "Unsubscribe"
    And I should be on the frontend list of newsletters
    And I should have 0 mailing_newsletter_subscriber