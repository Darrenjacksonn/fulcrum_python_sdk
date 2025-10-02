@echo off
powershell -ExecutionPolicy Bypass -File "aws_auth.ps1"
setlocal enableextensions enabledelayedexpansion

REM Capture the API key from PowerShell
for /f "tokens=2 delims==" %%i in ('powershell -ExecutionPolicy Bypass -File "aws_auth.ps1" ^| findstr "PYPI_API_KEY="') do set PYPI_API_KEY=%%i

REM Require PYPI_API_KEY to be set in the environment
if not defined PYPI_API_KEY (
  echo ERROR: PYPI_API_KEY environment variable is not set.
  echo Please set it, then re-run this script.
  exit /b 1
)

REM Ensure we run from this script's directory
cd /d "%~dp0"

echo You must be in your global python configuration to proceed, please confirm this. You must also confirm that you have iterated your version number in setup.py by 1.

REM Show Y/N prompt
echo.
choice /C YN /M "Do you want to continue"
if errorlevel 2 (
  echo Cancelled by user.
  exit /b 1
)



cd..

echo.
echo Cleaning previous build artifacts...
if exist dist (
  echo Removing dist directory...
  rmdir /s /q dist
)
if exist build (
  echo Removing build directory...
  rmdir /s /q build
)
for /d %%D in (*.egg-info) do (
  echo Removing %%D
  rmdir /s /q "%%D" 2>nul
)
echo Cleanup completed.

echo.
echo Building package...
python -m build
if errorlevel 1 goto :error

echo.
echo Verifying distribution files with twine...
python -m twine check dist\*
if errorlevel 1 goto :error

echo.
echo Uploading to PyPI...
python -m twine upload --repository pypi dist\* -u __token__ -p %PYPI_API_KEY%
if errorlevel 1 goto :error

echo.
echo Done.
exit /b 0

:error
echo.
echo An error occurred. Aborting.
exit /b 1
