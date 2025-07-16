@echo off
set TIMESTAMP=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
copy /Y ..\.env .\env_backup_%TIMESTAMP%.txt
@echo 环境变量备份完成：env_backup_%TIMESTAMP%.txt