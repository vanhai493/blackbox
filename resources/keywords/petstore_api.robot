*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${PETSTORE_BASE_URL}    https://petstore.swagger.io/v2
${PET_ENDPOINT}         /pet
&{DEFAULT_HEADERS}      Content-Type=application/json

*** Keywords ***
Initialize Petstore Test Session
    [Documentation]    Create a shared HTTP session and a random pet id for the tests.
    ${random_id}=    Evaluate    random.randint(100000, 999999)    random
    Set Suite Variable    ${PET_ID}    ${random_id}
    Create Session    petstore    ${PETSTORE_BASE_URL}    headers=${DEFAULT_HEADERS}
    Log    Using pet id: ${PET_ID}

Create Pet
    [Documentation]    Send a POST request to create a pet and return the response object.
    [Arguments]    ${pet_id}    ${name}    ${status}
    ${payload}=    Create Dictionary    id=${pet_id}    name=${name}    status=${status}
    ${response}=    POST On Session    petstore    ${PET_ENDPOINT}    json=${payload}
    Status Should Be    ${response}    200
    Log    Created pet response: ${response.text}
    [Return]    ${response}

Get Pet By Id
    [Documentation]    Send a GET request to retrieve a pet by id and return the response object.
    [Arguments]    ${pet_id}
    ${response}=    GET On Session    petstore    ${PET_ENDPOINT}/${pet_id}
    Status Should Be    ${response}    200
    Log    Retrieved pet response: ${response.text}
    [Return]    ${response}

Pet Response Should Contain Details
    [Documentation]    Confirm that the response text includes the pet id, name, and status.
    [Arguments]    ${response}    ${expected_id}    ${expected_name}    ${expected_status}
    ${response_text}=    Set Variable    ${response.text}
    ${expected_id_as_text}=    Convert To String    ${expected_id}
    Should Contain    ${response_text}    ${expected_id_as_text}
    Should Contain    ${response_text}    ${expected_name}
    Should Contain    ${response_text}    ${expected_status}
