@echo off
echo ========================================
echo Wikipedia Search Automation Test Runner
echo ========================================

echo Installing dependencies...
pip install -r requirements.txt

echo.
echo Running Wikipedia Search Tests...
robot --outputdir results tests/wikipedia_search.robot

echo.
echo Running Validation Tests...
robot --outputdir results tests/validation_tests.robot

echo.
echo Test execution completed!
echo Check results folder for detailed reports.
pause