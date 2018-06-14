@echo off
echo ================================================ 
echo  Windows������Oracle���ݿ���Զ����ݽű�
echo  1. ʹ�õ�ǰ�������������ļ���
echo  2. �Զ�ɾ��30��ǰ�ı��ݡ�
echo ================================================
::�ԡ�YYYYMMDD����ʽȡ����ǰʱ�䡣
set BACKUPDATE=%date:~0,4%%date:~5,2%%date:~8,2%
set CURTIME=%time:~0,2%
REM Сʱ�����С��10������ǰ�油0
if "%CURTIME%"==" 0" set CURTIME=00
if "%CURTIME%"==" 1" set CURTIME=01
if "%CURTIME%"==" 2" set CURTIME=02
if "%CURTIME%"==" 3" set CURTIME=03
if "%CURTIME%"==" 4" set CURTIME=04
if "%CURTIME%"==" 5" set CURTIME=05
if "%CURTIME%"==" 6" set CURTIME=06
if "%CURTIME%"==" 7" set CURTIME=07
if "%CURTIME%"==" 8" set CURTIME=08
if "%CURTIME%"==" 9" set CURTIME=09
set CURTIME=%CURTIME%%time:~3,2%%time:~6,2%

::�����û����������Ҫ���ݵ����ݿ⡣
set USER=ZLPC
set PASSWORD=zlpc
set DATABASE=orcl

::��������Ŀ¼��
set BACKUP_DIR=D:\datapump
if not exist "%BACKUP_DIR%\data\%BACKUPDATE%"     mkdir %BACKUP_DIR%\data\%BACKUPDATE%
rem if not exist "%BACKUP_DIR%\log\%BACKUPDATE%"      mkdir %BACKUP_DIR%\log\%BACKUPDATE%
set DATADIR=%BACKUP_DIR%\data\%BACKUPDATE%
rem set LOGDIR=%BACKUP_DIR%\log\%BACKUPDATE%

expdp %USER%/%PASSWORD%@zlpc schemas=%USER% directory=dmpdir DUMPFILE=%USER%_%BACKUPDATE%%CURTIME%.dmp logfile=%USER%_%BACKUPDATE%%CURTIME%.log  compression=all parallel=4 CLUSTER=N

if exist "%BACKUP_DIR%\%USER%_%BACKUPDATE%%CURTIME%.dmp" move %BACKUP_DIR%\%USER%_%BACKUPDATE%%CURTIME%.dmp %DATADIR%\%USER%_%BACKUPDATE%%CURTIME%.dmp  

if exist "%BACKUP_DIR%\%USER%_%BACKUPDATE%%CURTIME%.log" move %BACKUP_DIR%\%USER%_%BACKUPDATE%%CURTIME%.log %DATADIR%\%USER%_%BACKUPDATE%%CURTIME%.log 


::ɾ��30��ǰ�ı��ݡ�
forfiles /p "%DATADIR%" /s /m *.* /d -30 /c "cmd /c del @path"
rem forfiles /p "%LOGDIR%" /s /m *.* /d -30 /c "cmd /c del @path"
exit