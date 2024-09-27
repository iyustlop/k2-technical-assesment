Feature: Request users test.
  The /api/users/2 endpoint returns details of a specific user.
  Objective: Validate the data structure and specific content of the response.
  1. Sends a GET request to /api/users/2 and verifies that the response includes the expected fields.
  2. Validate data format of the different attributes returned in the response
  3. Do any other validations that you may think of.

  Background:
    * url baseUrl
    * def schema =
      """
      {
        data: {
          id:'#number',
          email: '#string? _.length > 0',
          first_name:'#string? _.length > 0',
          last_name:'#string? _.length > 0',
          avatar:'#string? _.length > 0'
        },
        support: {
          url:'#string? _.length > 0',
          text:'#string? _.length > 0'
        }
      }
      """

  Scenario: Scenario 2.1: get user info
    Given path 'users','2'
    When method get
    Then status 200
    And match response == schema


  Scenario: Scenario 2.3: Additional checks on headers and user id
    Given path 'users','2'
    When method get
    Then status 200
    And match header Access-Control-Allow-Origin contains '*'
    And match response.data.id == 2

