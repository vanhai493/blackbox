*** Settings ***
Library    SeleniumLibrary
Resource   ../variables/test_data.robot
Resource   browser_config.robot

*** Keywords ***
Open Wikipedia Homepage
    [Documentation]    Opens browser and navigates to Wikipedia homepage
    TRY
        Open Browser With Configuration    ${WIKIPEDIA_URL}    ${BROWSER}
        Set Browser Timeouts
        Wait Until Page Contains Element    ${SEARCH_INPUT}    timeout=${TIMEOUT}
        Page Should Contain Element    ${SEARCH_INPUT}
        Log    Successfully opened Wikipedia homepage
    EXCEPT    AS    ${error}
        Log    Error opening Wikipedia homepage: ${error}    level=ERROR
        Capture Page Screenshot    filename=error_opening_homepage.png
        Close Browser
        Fail    Failed to open Wikipedia homepage: ${error}
    END

Search For Keyword
    [Documentation]    Performs search operation with given keyword
    [Arguments]    ${keyword}
    TRY
        Wait Until Element Is Visible    ${SEARCH_INPUT}    timeout=${TIMEOUT}
        Clear Element Text    ${SEARCH_INPUT}
        Input Text    ${SEARCH_INPUT}    ${keyword}
        Log    Entered search keyword: ${keyword}
        
        # Click English Wikipedia link first
        Wait Until Element Is Visible    ${LANGUAGE_LINK}    timeout=${TIMEOUT}
        Click Element    ${LANGUAGE_LINK}
        
        # Wait for English Wikipedia page and search again
        Wait Until Page Contains Element    id=searchInput    timeout=${TIMEOUT}
        Clear Element Text    id=searchInput
        Input Text    id=searchInput    ${keyword}
        Press Keys    id=searchInput    RETURN
        Log    Submitted search for keyword: ${keyword}
    EXCEPT    AS    ${error}
        Log    Error during search operation: ${error}    level=ERROR
        Capture Page Screenshot    filename=error_search_operation.png
        Fail    Failed to search for keyword '${keyword}': ${error}
    END

Verify Search Results
    [Documentation]    Verifies that search results are displayed and contain expected content
    [Arguments]    ${expected_keyword}
    
    TRY
        # Wait for page to load and check if we're on a direct article page or search results
        Sleep    2s
        ${current_url}=    Get Location
        Log    Current URL: ${current_url}
        
        # Check if we landed on a direct article page (contains the keyword in URL)
        ${is_article_page}=    Run Keyword And Return Status    Should Contain    ${current_url}    wiki/
        
        Run Keyword If    ${is_article_page}
        ...    Verify Article Page    ${expected_keyword}
        ...    ELSE
        ...    Verify Search Results Page    ${expected_keyword}
    EXCEPT    AS    ${error}
        Log    Error during result verification: ${error}    level=ERROR
        Capture Page Screenshot    filename=error_verify_results.png
        Fail    Failed to verify search results for '${expected_keyword}': ${error}
    END

Verify Article Page
    [Documentation]    Verifies content on a direct article page
    [Arguments]    ${expected_keyword}
    TRY
        Wait Until Page Contains Element    ${PAGE_TITLE}    timeout=${TIMEOUT}
        ${page_title}=    Get Text    ${PAGE_TITLE}
        Log    Article page title: ${page_title}
        Should Contain    ${page_title}    ${expected_keyword}    ignore_case=True
        Page Should Contain    ${expected_keyword}
        Log    Successfully verified article page contains: ${expected_keyword}
    EXCEPT    AS    ${error}
        Log    Error verifying article page: ${error}    level=ERROR
        Capture Page Screenshot    filename=error_verify_article.png
        Fail    Failed to verify article page for '${expected_keyword}': ${error}
    END

Verify Search Results Page
    [Documentation]    Verifies content on search results page
    [Arguments]    ${expected_keyword}
    TRY
        Wait Until Page Contains Element    ${RESULTS_CONTAINER}    timeout=${TIMEOUT}
        Page Should Contain Element    ${SEARCH_RESULTS}
        ${results_count}=    Get Element Count    ${SEARCH_RESULTS}
        Should Be True    ${results_count} > 0    No search results found
        Page Should Contain    ${expected_keyword}
        Log    Successfully verified search results contain: ${expected_keyword}
    EXCEPT    AS    ${error}
        Log    Error verifying search results page: ${error}    level=ERROR
        Capture Page Screenshot    filename=error_verify_search_results.png
        Fail    Failed to verify search results page for '${expected_keyword}': ${error}
    END

Close Browser And Cleanup
    [Documentation]    Closes browser and performs cleanup
    Close Browser
    Log    Browser closed and cleanup completed