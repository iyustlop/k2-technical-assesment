Feature: Users pagination Test
  Validate pagination handling and the integrity of data across pages.
  Objective: The /api/users endpoint returns paginated data, allowing clients to request different pages of users.
  1. Sends a GET request to /api/users?page=2 and verifies the correct number of users is returned (default is 6 users per page).
  2. Validates that the page, per_page, total, and total_pages fields in the response contain accurate values.
  3. Fetches page 1 and page 2, and ensures that the users from the two pages are unique (i.e., no user appears on both pages).
  4. Attempts to access a non-existent page (e.g., /api/users?page=999) and verifies the API response handles this
     gracefully (should return an empty list or appropriate response).

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
          url:'#string? _.length > 0',
          text:'#string? _.length > 0'
        }
      }
      """
    * def dataSizeCheck = '#[6]'
    * def totalUserSize = '#[12]'
    * def dataEmptySize = '#[]'

  Scenario: Scenario 4.1: Check user size per page and schema
    Given path 'users'
    And param page = 2
    When method get
    Then status 200
    And match response.data == dataSizeCheck
    And match response == schema

  Scenario: Scenario 4.2: check the total user
    Given path 'users'
    And param page = 2
    When method get
    Then status 200
    And match response.page == 2
    And match response.per_page == 6
    And match response.total == 12
    And match response.total_pages == 2
    * def total = response.total
    * def perPage = response.per_page
    * def resTotalPages = total / perPage
    And match response.total_pages == resTotalPages

  Scenario: Scenario 4.3: check all user are unique
    Given path 'users'
    And param page = 1
    When method get
    Then status 200
    * def usersPage1 = response.data.map(x => x.email)
    Given path 'users'
    And param page = 2
    When method get
    Then status 200
    * def usersPage2 = response.data.map(x => x.email)
    * def users = karate.append(usersPage1,usersPage2)
    * def usersDistinct = karate.distinct(users)
    And match usersDistinct == totalUserSize

  Scenario: Scenario 4.3: check all user are unique
    Given path 'users'
    And param page = 999
    When method get
    Then status 200
    And match response.data == dataEmptySize
