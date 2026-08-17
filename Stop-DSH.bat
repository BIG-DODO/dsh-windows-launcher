@echo off
chcp 65001 >nul
:: ============================================================
::  DSH Windows 一键停止器
::  精确按端口 3080 找到 dsh 进程并结束，不影响其他程序
:: ============================================================
powershell -NoProfile -Command "try { $c = Get-NetTCPConnection -LocalPort 3080 -State Listen -ErrorAction Stop; $pid2 = $c.OwningProcess; Stop-Process -Id $pid2 -Force; Write-Host ('[DSH] 已停止 DSH (PID ' + $pid2 + ')') } catch { Write-Host '[DSH] 端口 3080 未监听，DSH 未在运行。' }; Start-Sleep -Seconds 1; try { Get-NetTCPConnection -LocalPort 3080 -State Listen -ErrorAction Stop; Write-Host '[DSH] 警告：端口仍被占用' } catch { Write-Host '[DSH] 端口已释放，DSH 已停止。' }"
exit /b 0
