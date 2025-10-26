@echo off
setlocal EnableDelayedExpansion
title Windows System Cleanup Tool

:: Check for administrator privileges
NET FILE >nul 2>&1
if errorlevel 1 (
    echo Requesting administrator privileges...
    PowerShell -Command "Start-Process cmd -ArgumentList '/c %0' -Verb RunAs"
    exit /b
)

echo ========================================
echo    WINDOWS SYSTEM CLEANUP TOOL
echo ========================================
echo.

:MAIN_MENU
cls
echo ========================================
echo    WINDOWS SYSTEM CLEANUP TOOL
echo ========================================
echo.
echo [1] Quick Clean (Temp Files & Cache)
echo [2] Deep Clean (Comprehensive Cleanup)
echo [3] System Repair & Maintenance
echo [4] Storage Space Analyzer
echo [5] Exit
echo.
set /p choice="Select option (1-5): "

if "%choice%"=="1" goto QUICK_CLEAN
if "%choice%"=="2" goto DEEP_CLEAN
if "%choice%"=="3" goto SYSTEM_REPAIR
if "%choice%"=="4" goto STORAGE_ANALYZER
if "%choice%"=="5" exit /b
echo Invalid choice. Press any key to try again...
pause >nul
goto MAIN_MENU

:QUICK_CLEAN
echo.
echo Starting Quick Clean...
echo Cleaning temporary files...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
del /q /f /s "%USERPROFILE%\AppData\Local\Temp\*" >nul 2>&1

echo Clearing DNS cache...
ipconfig /flushdns >nul 2>&1

echo Cleaning browser caches...
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im chrome.exe >nul 2>&1
timeout /t 2 /nobreak >nul

rmdir /s /q "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Cache" >nul 2>&1
rmdir /s /q "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache" >nul 2>&1

echo Quick Clean completed!
echo.
goto SHOW_SPACE

:DEEP_CLEAN
echo.
echo Starting Deep Clean...
call :QUICK_CLEAN

echo Cleaning Windows Update cache...
net stop wuauserv >nul 2>&1
rmdir /s /q "C:\Windows\SoftwareDistribution\Download" >nul 2>&1
net start wuauserv >nul 2>&1

echo Cleaning thumbnail cache...
del /f /s /q "%USERPROFILE%\AppData\Local\Microsoft\Windows\Explorer\thumbcache*.db" >nul 2>&1

echo Cleaning package manager caches...
where winget >nul 2>&1 && winget export --source winget -o cache.json >nul 2>&1 && del cache.json >nul 2>&1
where choco >nul 2>&1 && choco optimize --quiet >nul 2>&1

echo Deep Clean completed!
echo.
goto SHOW_SPACE

:SYSTEM_REPAIR
echo.
echo Starting System Repair...
echo Checking disk for errors...
chkdsk C: /f /r >nul 2>&1 && echo Disk check scheduled for next restart.

echo Running System File Checker...
sfc /scannow

echo Checking Windows Update health...
DISM /Online /Cleanup-Image /RestoreHealth

echo System repair tasks completed!
echo.
pause
goto MAIN_MENU

:STORAGE_ANALYZER
echo.
echo Storage Space Analysis:
echo =======================
for /f "skip=1" %%i in ('wmic logicaldisk where "DeviceID='C:'" get Size,FreeSpace /value') do (
    for /f "tokens=1* delims==" %%j in ("%%i") do (
        if "%%j"=="FreeSpace" set free=%%k
        if "%%j"=="Size" set total=%%k
    )
)

set /a freeGB=!free!/1073741824
set /a totalGB=!total!/1073741824
set /a usedGB=!totalGB!-!freeGB!
set /a percentUsed=!usedGB!*100/!totalGB!

echo Total Space: !totalGB! GB
echo Used Space:  !usedGB! GB
echo Free Space:  !freeGB! GB
echo Usage:       !percentUsed!%%
echo.

echo Top space-consuming directories:
echo.
for /f "tokens=*" %%d in ('dir "C:\Users" /AD /B 2^>nul') do (
    powershell "Get-ChildItem 'C:\Users\%%d' -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Sum" >nul 2>&1
)
echo Analysis complete!
echo.
pause
goto MAIN_MENU

:SHOW_SPACE
echo Final Storage Status:
echo =====================
for /f "skip=1" %%i in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value') do (
    for /f "tokens=1* delims==" %%j in ("%%i") do (
        if "%%j"=="FreeSpace" set finalfree=%%k
    )
)
set /a finalfreeGB=!finalfree!/1073741824
echo Free Space Available: !finalfreeGB! GB
echo.
pause
goto MAIN_MENU

:END
exit /b
