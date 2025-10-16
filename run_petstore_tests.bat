@echo off
echo ========================================
echo Running Petstore API Tests
echo ========================================
echo.

robot tests/petstore_api_tests.robot

echo.
echo ========================================
echo Test execution completed!
echo Check report.html for detailed results
echo ========================================
pause
