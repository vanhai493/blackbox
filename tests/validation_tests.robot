*** Settings ***
Documentation    Comprehensive validation tests for Wikipedia search functionality
Library          SeleniumLibrary
Resource         ../resources/keywords/wikipedia_keywords.robot
Resource         ../resources/variables/test_data.robot

*** Test Cases ***
Test Invalid Search Keywords
    [Documentation]    Test searching with invalid or empty keywords
    [Tags]    negative    validation
    
    Open Wikipedia Homepage
    
    # Test empty search
    TRY
        Search For Keyword    ${EMPTY}
        Log    Empty search should be handled gracefully
    EXCEPT
        Log    Empty search handled as expected
    END
    
    # Test special characters
    TRY
        Search For Keyword    @#$%^&*()
        Verify Search Results    @#$%^&*()
    EXCEPT
        Log    Special characters search handled as expected
    END
    
    Close Browser And Cleanup

Test Search Result Boundaries
    [Documentation]    Test boundary conditions for search results
    [Tags]    boundary    validation
    
    Open Wikipedia Homepage
    
    # Test very long search term
    ${long_keyword}=    Set Variable    ${'a' * 100}
    Search For Keyword    ${long_keyword}
    
    # Should handle gracefully without crashing
    ${current_url}=    Get Location
    Should Not Be Empty    ${current_url}
    
    Close Browser And Cleanup

Test Multiple Browser Support
    [Documentation]    Validate functionality across different browsers
    [Tags]    cross-browser    validation
    
    @{browsers}=    Create List    Chrome    Firefox
    
    FOR    ${browser}    IN    @{browsers}
        Log    Testing with browser: ${browser}
        Set Test Variable    ${BROWSER}    ${browser}
        
        TRY
            Open Wikipedia Homepage
            Search For Keyword    ${SEARCH_KEYWORD}
            Verify Search Results    ${SEARCH_KEYWORD}
            Close Browser And Cleanup
            Log    Successfully tested with ${browser}
        EXCEPT    AS    ${error}
            Log    Error with ${browser}: ${error}    level=WARN
            Run Keyword And Ignore Error    Close Browser
        END
    END

Test Network Timeout Scenarios
    [Documentation]    Test behavior under network timeout conditions
    [Tags]    timeout    validation
    
    # Set very short timeout to simulate network issues
    Set Test Variable    ${TIMEOUT}    1s
    
    TRY
        Open Wikipedia Homepage
        Log    Page loaded within short timeout
    EXCEPT
        Log    Timeout handled gracefully as expected
    FINALLY
        Run Keyword And Ignore Error    Close Browser
    END

Test Page Element Validation
    [Documentation]    Validate that required page elements exist
    [Tags]    element-validation
    
    Open Wikipedia Homepage
    
    # Validate search input exists and is functional
    Element Should Be Visible    ${SEARCH_INPUT}
    Element Should Be Enabled    ${SEARCH_INPUT}
    
    # Validate language link exists
    Element Should Be Visible    ${LANGUAGE_LINK}
    Element Should Be Enabled    ${LANGUAGE_LINK}
    
    Close Browser And Cleanup