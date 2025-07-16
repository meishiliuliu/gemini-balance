@echo off
set BACKUP_DIR=./backup
mkdir %BACKUP_DIR% 2>nul
set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
copy .env %BACKUP_DIR%\env_backup_%TIMESTAMP%.bak
if %errorlevel% equ 0 (
echo 环境变量备份成功: %BACKUP_DIR%\env_backup_%TIMESTAMP%.bak
) else (
echo 环境变量备份失败
)