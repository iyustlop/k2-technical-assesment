Feature: Request Non existing user
  The /api/users/{id} endpoint is used to retrieve a user by id. When the user does not exist, the API should return a 404 Not Found.
  Objective: Test the behavior of the API when trying to access a resource that does not exist. Task: • Write a test that:
  1. Sends a GET request to /api/users/23 (a non-existent user) and verifies that the response status is 404 Not Found.
  2. Ensures that the response body is empty and no additional information is provided.
  3. Checks how the API handles malformed id values (e.g., /api/users/abc) and verifies whether an appropriate error or
     status code is returned.

  Background:
    * url baseUrl

  Scenario: Scenario 5.1. get a non-existing user
    Given path 'users', '29'
    When method get
    Then status 404
    And match response == {}

  Scenario: Scenario 5.3. malformed path
    Given path 'users', 'abx'
    When method get
    Then status 400
    And match response == {}



