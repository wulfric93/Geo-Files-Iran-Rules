@echo off
:: Set log file name
set LOG_FILE="GeoFile_Downloader.log"

:: Set URLs for the files
set GEOIP_DB_URL=https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/release/geoip.db
set GEOSITE_DB_URL=https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/release/geosite.db
set GEOIP_DAT_URL=https://raw.githubusercontent.com/Chocolate4U/Iran-v2ray-rules/release/geoip.dat
set GEOSITE_DAT_URL=https://raw.githubusercontent.com/Chocolate4U/Iran-v2ray-rules/release/geosite.dat

:: Greeting and title message
echo -------------------------------------------------------
echo Chocolate4U : Iran Domain and IP Geo Files for v2ray - Sing Box Rules Downloader >> "%LOG_FILE%"
echo https://github.com/Chocolate4U
echo ------------------------------------------------------- >> "%LOG_FILE%"

:: Function to search for a folder containing the geo files starting from current directory
set DEST_DIR=
for /d %%F in (*.*) do (
    if exist "%%F\geoip.db" set DEST_DIR=%%F
    if exist "%%F\geosite.db" set DEST_DIR=%%F
    if exist "%%F\geoip.dat" set DEST_DIR=%%F
    if exist "%%F\geosite.dat" set DEST_DIR=%%F
)

:: Check if DEST_DIR was found, if not use current directory
if "%DEST_DIR%"=="" set DEST_DIR=%cd%

echo Destination directory found: %DEST_DIR%
echo -------------------------------------------------------

:: Remove existing geo files
echo Removing existing geo files... >> "%LOG_FILE%"
del "%DEST_DIR%\geoip.db" 2>nul
del "%DEST_DIR%\geosite.db" 2>nul
del "%DEST_DIR%\geoip.dat" 2>nul
del "%DEST_DIR%\geosite.dat" 2>nul

:: Download new files
call :DownloadFile "%DEST_DIR%\geoip.db" "%GEOIP_DB_URL%" geoip.db
call :DownloadFile "%DEST_DIR%\geosite.db" "%GEOSITE_DB_URL%" geosite.db
call :DownloadFile "%DEST_DIR%\geoip.dat" "%GEOIP_DAT_URL%" geoip.dat
call :DownloadFile "%DEST_DIR%\geosite.dat" "%GEOSITE_DAT_URL%" geosite.dat

echo GeoFile Downloader finished at %date% %time% >> "%LOG_FILE%"
echo ------------------------------------------------------- >> "%LOG_FILE%"
exit /b

:DownloadFile
setlocal
set FILE_PATH=%1
set FILE_URL=%2
set FILE_NAME=%3

:: Display the file name being downloaded
echo Downloading %FILE_NAME%...
echo Downloading %FILE_NAME%... >> "%LOG_FILE%"

:: Download the new file
powershell -Command "Invoke-WebRequest -Uri '%FILE_URL%' -OutFile '%FILE_PATH%'" >> "%LOG_FILE%" 2>&1
if %ERRORLEVEL% equ 0 (
    echo %FILE_NAME% downloaded successfully! >> "%LOG_FILE%"
    echo %FILE_NAME% downloaded successfully!
) else (
    echo Failed to download %FILE_NAME%! >> "%LOG_FILE%"
    echo Failed to download %FILE_NAME%!
)
endlocal
exit /b
