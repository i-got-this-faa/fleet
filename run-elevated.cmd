@echo off
cd /d "%~dp0"
echo ========================================================
echo Running Fleet Elevated Tests...
echo ========================================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tests\elevated-runner.ps1"
echo.
echo ========================================================
echo Merging test results via tests\run.ps1...
echo ========================================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tests\run.ps1"
echo.
pause
