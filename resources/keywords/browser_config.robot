*** Settings ***
Library    SeleniumLibrary
Resource   ../variables/test_data.robot

*** Keywords ***
Setup Chrome Browser
    [Documentation]    Configure Chrome browser with specific options
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --disable-blink-features=AutomationControlled
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Run Keyword If    '${HEADLESS}' == 'True'    Call Method    ${chrome_options}    add_argument    --headless
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Set Window Size    1920    1080
    RETURN    ${chrome_options}

Setup Firefox Browser
    [Documentation]    Configure Firefox browser with specific options
    ${firefox_options}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
    Run Keyword If    '${HEADLESS}' == 'True'    Call Method    ${firefox_options}    add_argument    --headless
    Create Webdriver    Firefox    firefox_options=${firefox_options}
    Set Window Size    1920    1080
    RETURN    ${firefox_options}

Setup Edge Browser
    [Documentation]    Configure Edge browser with specific options
    ${edge_options}=    Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys, selenium.webdriver
    Call Method    ${edge_options}    add_argument    --disable-blink-features=AutomationControlled
    Run Keyword If    '${HEADLESS}' == 'True'    Call Method    ${edge_options}    add_argument    --headless
    Create Webdriver    Edge    edge_options=${edge_options}
    Set Window Size    1920    1080
    RETURN    ${edge_options}

Open Browser With Configuration
    [Documentation]    Opens browser with proper configuration based on browser type
    [Arguments]    ${url}    ${browser_name}=${BROWSER}
    
    Run Keyword If    '${browser_name}' == 'Chrome'    Setup Chrome Browser
    ...    ELSE IF    '${browser_name}' == 'Firefox'    Setup Firefox Browser  
    ...    ELSE IF    '${browser_name}' == 'Edge'    Setup Edge Browser
    ...    ELSE    Open Browser    ${url}    ${browser_name}
    
    Go To    ${url}
    Run Keyword If    '${HEADLESS}' == 'False'    Maximize Browser Window

Set Browser Timeouts
    [Documentation]    Configure browser timeouts
    Set Browser Implicit Wait    ${TIMEOUT}
    Set Selenium Timeout    ${TIMEOUT}
    Set Selenium Speed    0.5s