Feature: Login token Test
  The /api/login endpoint is used for user authentication and requires both email and password for successful login.
    However, incomplete login details should result in error responses.
    Objective: Test both successful and failed login attempts and ensure the API handles missing fields appropriately.
    Task: • Write a test that:

  1. Sends a POST request with valid credentials ({email: "eve.holt@reqres.in", password:"cityslicka" }) and verifies that
    the response includes a 200 OK status and a valid token field.
  2. Sends a POST request with only the email (no password) and verifies the response status is 400 and the message is
     {"error": "Missing password"}.
  3. Sends a POST request without email and verifies the appropriate error is returned ({"error":"Missing email or username"}).
  4. Any validation related to headers that you may think?
  5. Do any other validations that you see fit.

  Background:
    * url baseUrl
    * def missingPassword = { error: 'Missing password' }
    * def missingEmailOrUser = { error: 'Missing email or username' }
    * def schema = { group:"#string", max_age :'#number', endpoints :[{ url:'#string'}] }
    * def userNotFound = { error: 'user not found'}

  Scenario: Scenario 1.1. get a valid token with valid credentials
    * def credentials =
    """
    {
      "email": "eve.holt@reqres.in",
      "password": "cityslicka"
    }
    """
    Given path 'login'
    And request credentials
    When method post
    Then status 200
    And match response == { token: '#string' }

  Scenario: Scenario 1.2: get a error message "Missing password" - missing value
    * def wrongCredentials =
      """
      {
        "email": "eve.holt@reqres.in"
      }
      """
    Given path 'login'
    And request wrongCredentials
    When method post
    Then status 400
    And match response == missingPassword

  Scenario: Scenario 1.2: get a error message "Missing password" - wrong value
    * def wrongCredentials =
      """
      {
        "email": "eve.holt@reqres.in",
        "contraseña": "cityslicka"
      }
      """
    Given path 'login'
    And request wrongCredentials
    When method post
    Then status 400
    And match response == missingPassword

  Scenario: Scenario 1.3: get a error message "Missing password" - missing value
    * def wrongCredentials =
      """
      {
        "password": "cityslicka"
      }
      """
    Given path 'login'
    And request wrongCredentials
    When method post
    Then status 400
    And match response == missingEmailOrUser

  Scenario: Scenario 1.3: get a error message "Missing password" - wrong value
    * def wrongCredentials =
      """
      {
        "correo": "eve.holt@reqres.in",
        "password": "cityslicka"
      }
      """
    Given path 'login'
    And request wrongCredentials
    When method post
    Then status 400
    And match response == missingEmailOrUser

  Scenario: Scenario 1.4:  get a valid token with valid credentials - check headers
    * def credentials =
      """
      {
        "email": "eve.holt@reqres.in",
        "password": "cityslicka"
      }
      """
    Given path 'login'
    And request credentials
    When method post
    Then status 200
    And match header Content-Type contains 'application/json'
    And match header Content-Type contains 'charset=utf-8'

  Scenario: Scenario 1.5: Additional - wrong user
    * def credentials =
      """
      {
        "email": "john.snow@reqres.in",
        "password": "cityslicka"
      }
      """
    Given path 'login'
    And request credentials
    When method post
    Then status 404
    Then match response == userNotFound

  Scenario: Scenario 1.5: Additional - email from other domain
    * def credentials =
      """
      {
        "email": "john.snow@gmail.com",
        "password": "cityslicka"
      }
      """
    Given path 'login'
    And request credentials
    When method post
    Then status 404
    Then match response == userNotFound

  Scenario: Scenario 1.5: Additional - wrong password
    * def credentials =
      """
      {
        "email": "eve.holt@reqres.in",
        "password": "mickeymouse"
      }
      """
    Given path 'login'
    And request credentials
    When method post
    Then status 403
    Then match response == { error: 'You are not authorized'}

  Scenario: Scenario 1.5: Additional checks on headers
    * def credentials =
      """
      {
        "email": "eve.holt@reqres.in",
        "password": "cityslicka"
      }
      """
    Given path 'login'
    And request credentials
    When method post
    Then status 200
    * def headers = responseHeaders['Report-To'][0]
    * def reportTo = karate.fromString(headers)
    And match reportTo == schema