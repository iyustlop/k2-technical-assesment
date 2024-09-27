Feature: Bonus Question 2: Pagination
  You want to retrieve users from page 1 and page 2, ensuring that users are not duplicated across pages
  and that each user has valid field values.
  Objective: Test pagination, ensuring user consistency and validating field structures across multiple
  pages of users.
  1. Send a GET request to /api/users?page=1 and validate that the response contains a list of users with
     fields id, email, first_name, last_name, and avatar.
  2. Send a GET request to /api/users?page=2 and perform the same validation for the users on page
  3. Ensure that no id from the user list on page 1 appears in the user list from page 2
  (i.e., no duplicate users between pages).
  4. Check that each user’s fields, such as email, first_name, and last_name, contain valid non-empty values.
  5. Verify that the total number of users per page matches the per_page field in the response (should be 6
     users per page).

  Background:
    * url baseUrl
    * def userSchema =
    """
    {
      id:'#number',
      email:'#string? _.length > 0',
      first_name:'#string? _.length > 0',
      last_name:'#string? _.length > 0',
      avatar:'#string? _.length > 0'
    }
    """

    * def schema =
      """
      {
        page: '#number',
        per_page: '#number',
        total: '#number',
        total_pages:'#number',
        data: '##[_ > 0] userSchema',
        support: {
          url:'#string',
          text:'#string'
        }
      }
      """

  Scenario Outline: Scenario B.2: Check response schema of page 1 and 2 and users size equal 6 and check is non empty
    Given path 'users'
    And param page = <page>
    When method get
    Then status 200
    And match response == schema

    Examples:
      | page |
      | 1    |
      | 2    |

  Scenario: Scenario B.2: check all user are unique
    * def fun = function(x){ return x.id}
    Given path 'users'
    And param page = 1
    When method get
    Then status 200
    * def totalUsers = response.total
    * def usersPage1 = karate.jsonPath(response.data, '$..id')
    And print usersPage1
    Given path 'users'
    And param page = 2
    When method get
    Then status 200
    * def usersPage2 = karate.jsonPath(response.data, '$..id')
    * def users = karate.append(usersPage1,usersPage2)
    * def usersDistinct = karate.distinct(users)
    And match usersDistinct == '#[totalUsers]'