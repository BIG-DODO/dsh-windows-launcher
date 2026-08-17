@echo off
chcp 65001 >nul
setlocal
:: ============================================================
::  DSH Windows 一键启动器  (DeepSeek Harness web launcher)
::  双击本文件 → 后台静默启动 dsh web → 自动打开浏览器
::  停止请用同目录的 Stop-DSH.bat
:: ============================================================

set "PORT=3080"

:: ===== 1) 工作目录（存放 dsh 配置/会话，按需修改）=====
:: 默认放在用户目录下；如需指定，改成你的路径，例如：
:: set "WORK_DIR=D:\00-DSH专属工作区"
set "WORK_DIR=%USERPROFILE%\DSH-Workspace"

:: ===== 2) 自动探测 dsh 路径（双击 .bat 时 PATH 可能不含 npm）=====
:: 优先用 where 找完整路径；找不到再回退到 npm 全局默认位置
set "DSH="
for /f "delims=" %%p in ('where dsh.cmd 2^>nul') do set "DSH=%%p"
if not defined DSH (
  if exist "%APPDATA%\npm\dsh.cmd" set "DSH=%APPDATA%\npm\dsh.cmd"
)
if not defined DSH (
  echo [DSH] 找不到 dsh，请先执行：npm install -g @deepseek-ai/dsh
  echo [DSH] 或在下方手动指定路径，例如：
  echo [DSH]   set "DSH=C:\Users\你的用户名\AppData\Roaming\npm\dsh.cmd"
  pause
  exit /b 1
)
:: 顺手把 npm 加进 PATH，避免子进程找不到命令
set "PATH=%PATH%;%APPDATA%\npm"

:: ===== 3) 准备工作目录 =====
if not exist "%WORK_DIR%" mkdir "%WORK_DIR%"

:: ===== 4) 清理可能残留的旧进程（同一端口）=====
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%PORT%" ^| findstr "LISTENING"') do (
  taskkill /PID %%a /F >nul 2>&1
)
timeout /t 1 >nul

:: ===== 5) 完全脱离进程树、隐藏窗口后台启动 dsh web =====
:: 关键：用 Start-Process -WindowStyle Hidden，关掉启动器窗口也不会杀掉 dsh
powershell -NoProfile -Command "Start-Process -FilePath '%DSH%' -ArgumentList 'web' -WorkingDirectory '%WORK_DIR%' -WindowStyle Hidden"

:: ===== 6) 等待端口就绪（最多 120 秒）=====
set "i=0"
:wait
timeout /t 3 >nul
netstat -an | findstr /r ":%PORT% .*LISTENING" >nul
if %errorlevel%==0 goto opened
set /a i+=1
if %i% lss 40 goto wait

echo [DSH] dsh web 启动较慢或失败，请检查 dsh 是否安装/路径是否正确。
pause
exit /b 1

:opened
if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
  start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --app=http://127.0.0.1:%PORT%/
) else (
  start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --app=http://127.0.0.1:%PORT%/
)
endlocal
