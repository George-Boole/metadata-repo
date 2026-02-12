@echo off
title DAF Metadata Repository - Dev Server
echo.
echo  Starting DAF Metadata Repository...
echo.
cd /d "%~dp0"

:: Clean stale build cache to ensure Tailwind CSS loads correctly
if exist ".next" (
    echo  Clearing stale build cache...
    rmdir /s /q ".next"
)

echo  Once ready, open http://localhost:3000 in your browser.
echo  Press Ctrl+C to stop the server.
echo.
start http://localhost:3000
npm run dev
