@echo off
setlocal enabledelayedexpansion

:: 读取.env文件中的环境变量
for /f "tokens=1,2 delims==" %%a in (../.env) do (
    if "%%a"=="MYSQL_ROOT_PASSWORD" set "MYSQL_ROOT_PASSWORD=%%b"
    if "%%a"=="MYSQL_DATABASE" set "MYSQL_DATABASE=%%b"
)

:: 设置备份目录
set "BACKUP_DIR=./backups"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:: 生成时间戳
set "TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "BACKUP_FILE=%BACKUP_DIR%/backup_%TIMESTAMP%.sql"

:: 执行备份命令
docker exec gemini-balance-mysql mysqldump -u root -p%MYSQL_ROOT_PASSWORD% %MYSQL_DATABASE% > "%BACKUP_FILE%"

:: 检查备份是否成功
if %errorlevel% equ 0 (
    echo Backup completed successfully: %BACKUP_FILE%
    
    :: 清理旧备份：保留最近30天且至少保留3个备份
    echo Cleaning up old backups...
    powershell -Command "& { Get-ChildItem -Path '%BACKUP_DIR%' -Filter *.sql | Sort-Object LastWriteTime -Descending | Select-Object -Skip 3 | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force }"
    
    :: 可选：压缩备份文件
    :: powershell Compress-Archive -Path "%BACKUP_FILE%" -DestinationPath "%BACKUP_FILE%.zip" -Force
    :: if %errorlevel% equ 0 del "%BACKUP_FILE%"
) else (
    echo Backup failed
    exit /b 1
)

endlocal