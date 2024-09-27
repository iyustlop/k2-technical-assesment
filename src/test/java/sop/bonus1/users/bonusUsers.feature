Feature: Bonus 1: Chained Request
  You want to first fetch a list of users and then retrieve detailed information about one of those users
  Objective: Interact with the list of users and retrieve specific user details based on the list.
  1. Think about the possibles validations you could do here
  2. Have in mind clean code and reusability
  3. Validate that data from api/users is the same as api/users/{id}
  4. Do any other validations that you may think.
  5. Try to think any possible way of completing this task in a not correct way. This can be a couple of paragraphs (just text).

  Background:
    * url baseUrl
    * def myUser = 5

  Scenario: Bonus 1:
    Given path 'users'
    When method get
    Then status 200
    * def userRetrievedFromUsers = response.data[myUser]
    And print userRetrievedFromUsers
    Given path 'users', `${userRetrievedFromUsers.id}`
    When method get
    Then status 200
    And match response.data == userRetrievedFromUsers


  