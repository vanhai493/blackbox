*** Settings ***
Documentation    Wikipedia Search Automation Test Suite
...              This test suite automates searching for keywords on Wikipedia
...              and verifies the search results.

Library          SeleniumLibrary
Resource         ../resources/keywords/wikipedia_keywords.robot
Resource         ../resources/variables/test_data.robot

Suite Setup      Log    Starting Wikipedia Search Test Suite
Suite Teardown   Log    Wikipedia Search Test Suite Completed
Test Teardown    Run Keyword If Test Failed    Capture Page Screenshot

*** Test Cases ***
Search Apple On Wikipedia
    [Documentation]    Test case to search for "Apple" on Wikipedia and verify results
    [Tags]    smoke    wikipedia    search
    
    [Setup]    Log    Starting Apple search test
    
    # Step 1: Open Wikipedia homepage
    Open Wikipedia Homepage
    
    # Step 2: Search for the keyword "Apple"
    Search For Keyword    ${SEARCH_KEYWORD}
    
    # Step 3: Verify search results
    Verify Search Results    ${SEARCH_KEYWORD}
    
    [Teardown]    Close Browser And Cleanup

Search Multiple Keywords
    [Documentation]    Test case to search for multiple keywords on Wikipedia
    [Tags]    regression    wikipedia    search
    
    @{keywords}=    Create List    Apple    Microsoft    Google
    
    FOR    ${keyword}    IN    @{keywords}
        Log    Testing search for: ${keyword}
        Open Wikipedia Homepage
        Search For Keyword    ${keyword}
        Verify Search Results    ${keyword}
        Close Browser And Cleanup
    END

Test Search Result Content Validation
    [Documentation]    Detailed validation of search result content
    [Tags]    content-validation    detailed
    
    Open Wikipedia Homepage
    Search For Keyword    ${SEARCH_KEYWORD}
    
    # Additional content validations
    ${page_source}=    Get Source
    Should Contain    ${page_source}    Apple
    
    # Check if we're on article page or search results
    ${current_url}=    Get Location
    ${is_article}=    Run Keyword And Return Status    Should Contain    ${current_url}    wiki/Apple
    
    Run Keyword If    ${is_article}
    ...    Log    Successfully navigated to Apple article page
    ...    ELSE
    ...    Log    On search results page with Apple results
    
    Close Browser And Cleanup