@echo off
echo ========================================
echo Wikipedia Apple Search Test
echo ========================================

echo Installing dependencies...
pip install -r requirements.txt

echo.
echo Running Apple Search Test...
robot --outputdir results --test "Search Apple On Wikipedia" tests/wikipedia_search.robot

echo.
echo Test execution completed!
echo Check results folder for detailed reports.
pause