@echo off
title DAF Metadata Repository - Dev Server
echo.
echo  Starting DAF Metadata Repository...
echo  Once ready, open http://localhost:3000 in your browser.
echo  Press Ctrl+C to stop the server.
echo.
cd /d "%~dp0"
start http://localhost:3000
npm run dev
