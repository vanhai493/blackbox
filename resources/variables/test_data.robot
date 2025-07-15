*** Variables ***
# Wikipedia URLs and Settings
${WIKIPEDIA_URL}        https://www.wikipedia.org
${SEARCH_KEYWORD}       Apple
${BROWSER}              Chrome
${TIMEOUT}              10s
${HEADLESS}             False

# Wikipedia Homepage Elements
${SEARCH_INPUT}         id=searchInput
${SEARCH_BUTTON}        xpath=//button[@type='submit']
${LANGUAGE_LINK}        xpath=//a[@lang='en']

# Search Results Elements
${RESULTS_CONTAINER}    id=mw-content-text
${FIRST_RESULT}         css=.mw-search-result-heading a
${SEARCH_RESULTS}       css=.mw-search-result
${PAGE_TITLE}           css=h1.firstHeading

# Expected Results
${EXPECTED_TITLE}       Apple
${EXPECTED_CONTENT}     Apple Inc.