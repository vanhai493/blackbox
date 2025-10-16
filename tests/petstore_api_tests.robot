*** Settings ***
Documentation    Petstore API Test Suite
...              This test suite demonstrates how to use Robot Framework with RequestsLibrary
...              to test REST APIs. We test the Petstore API at https://petstore.swagger.io
...              Easy to read and understand for beginners.
Library          Collections
Library          String
Resource         ../resources/keywords/petstore_api.robot

Suite Setup      Initialize Petstore Test Session
Suite Teardown   Log    Petstore API Test Suite Completed

*** Test Cases ***
Test POST - Create a New Pet
    [Documentation]    Create a new pet using POST and confirm the response.
    [Tags]    post    api    smoke
    Log    Step 1: Creating a new pet with id ${PET_ID}
    ${create_response}=    Create Pet    ${PET_ID}    Fluffy    available
    Log    Step 2: Checking the API response for the created pet
    Pet Response Should Contain Details    ${create_response}    ${PET_ID}    Fluffy    available
    Log    Successfully created pet with name Fluffy

Test GET - Retrieve Pet by ID
    [Documentation]    Create a pet and retrieve it using GET by its id.
    [Tags]    get    api    smoke
    Log    Step 1: Creating a pet to retrieve
    ${pet_id}=    Evaluate    random.randint(200000, 299999)    random
    ${create_response}=    Create Pet    ${pet_id}    Buddy    available
    Log    Step 2: Retrieving pet with id ${pet_id}
    ${get_response}=    Get Pet By Id    ${pet_id}
    Log    Step 3: Verifying the retrieved pet information
    Pet Response Should Contain Details    ${get_response}    ${pet_id}    Buddy    available
    Log    Successfully retrieved pet with name Buddy

Test POST and GET Together - Complete Workflow
    [Documentation]    Demonstrate a full workflow of creating and retrieving a pet.
    [Tags]    workflow    integration    post    get
    Log    Step 1: POST - Creating a new pet
    ${new_pet_id}=    Evaluate    random.randint(300000, 399999)    random
    ${pet_name}=    Set Variable    Max
    ${pet_status}=    Set Variable    sold
    ${post_response}=    Create Pet    ${new_pet_id}    ${pet_name}    ${pet_status}
    Log    Pet created with id ${new_pet_id}
    Log    Step 2: GET - Retrieving the created pet
    ${get_response}=    Get Pet By Id    ${new_pet_id}
    Log    Step 3: Comparing POST and GET responses
    Pet Response Should Contain Details    ${post_response}    ${new_pet_id}    ${pet_name}    ${pet_status}
    Pet Response Should Contain Details    ${get_response}    ${new_pet_id}    ${pet_name}    ${pet_status}
    Log    Complete workflow successful for pet ${pet_name}

Test Multiple Pets with Different Statuses
    [Documentation]    Create and verify multiple pets with different statuses in a loop.
    [Tags]    multiple    post    get
    @{pet_data}=    Create List
    ...    available:Charlie
    ...    pending:Luna
    ...    sold:Cooper
    FOR    ${pet_info}    IN    @{pet_data}
        ${status}    ${name}=    Split String    ${pet_info}    :
        ${pet_id}=    Evaluate    random.randint(400000, 499999)    random
        Log    Creating pet ${name} with status ${status}
        ${post_response}=    Create Pet    ${pet_id}    ${name}    ${status}
        Log    Retrieving pet ${name}
        ${get_response}=    Get Pet By Id    ${pet_id}
        Pet Response Should Contain Details    ${get_response}    ${pet_id}    ${name}    ${status}
        Log    Finished verifying pet ${name}
    END
    Log    All pets created and verified successfully
