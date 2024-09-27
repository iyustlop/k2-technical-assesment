Feature: Create User Test
  The /api/users endpoint allows creating a user by sending a POST request with name and job fields.
  Objective: Test the API's response to various invalid inputs when creating a user.
  1. Sends a POST request with valid name and job fields (e.g., name: "John", job: "developer") and validates that the
     user is successfully created (status 201).
  2. Do any other possible combinations that you may see fit, such as: missing fields (no name, no job), different
     possible headers, etc.
  3. Do any other validations that you may see fit.

  Background:
    * url baseUrl
    * def schema =
      """
      {
        name:'John',
        job:'developer',
        id:'#string? _.length > 0',
        createdAt:'#string? _.length > 0'
      }
      """
    * def errorMissingJob = { error: 'Missing job' }
    * def errorMissingName = { error: 'Missing name' }
    * def errorAlreadyExists = { error: 'User already exist' }

  Scenario: Scenario 3.1: create a new user
    * def user =
      """
      {
        "name": "John",
        "job": "developer"
      }
      """
    Given path 'users'
    And request user
    When method post
    Then status 201
    And match response == schema

  Scenario: Scenario 3.2: create a new user - missing value job
    * def user =
      """
      {
        "name": "John"
      }
      """
    Given path 'users'
    And request user
    When method post
    Then status 400
    And match response == errorMissingJob

  Scenario: Scenario 3.2: create a new user - wrong value trabajo
    * def user =
      """
      {
        "name": "John",
        "trabajo": "developer"
      }
      """
    Given path 'users'
    And request user
    When method post
    Then status 400
    And match response == errorMissingJob

  Scenario: Scenario 3.2: create a new user - missing value name
    * def user =
      """
      {
        "job": "developer"
      }
      """
    Given path 'users'
    And request user
    When method post
    Then status 400
    And match response == errorMissingName

  Scenario: Scenario 3.2: create a new user - wrong value nombre
    * def user =
      """
      {
        "nombre": "John",
        "job": "developer"
      }
      """
    Given path 'users'
    And request user
    When method post
    Then status 400
    And match response == errorMissingName

  Scenario: Scenario 3.2: create a new user - wrong value header Content Type
    * def user =
      """
      {
        "nombre": "John",
        "job": "developer"
      }
      """
    And karate.configure('headers', { 'Content-Type': 'application/text' })
    Given path 'users'
    And request user
    When method post
    Then status 400
    And match response == errorMissingName

  Scenario: Scenario 3.3: Additional - add an existing user
    * def user =
      """
      {
        "name": "Janet",
        "job": "developer"
      }
      """
    And karate.configure('headers', { 'Content-Type': 'application/json' })
    Given path 'users'
    And request user
    When method post
    Then status 409
    And match response == errorAlreadyExists

  Scenario: Scenario 3.3: Additional - add an existing user from users
    * def user =
      """
      {
        "email":"janet.weaver@reqres.in",
        "first_name":"Janet",
        "last_name":"Weaver",
        "avatar":"https://reqres.in/img/faces/2-image.jpg"
      }
      """
    And karate.configure('headers', { 'Content-Type': 'application/json' })
    Given path 'users'
    And request user
    When method post
    Then status 409
    And match response == errorAlreadyExists
