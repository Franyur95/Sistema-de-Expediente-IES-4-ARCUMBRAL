@echo off
rem Copia de seguridad de la base del S.I.E.A. Ajuste las rutas si su instalacion es distinta.
rem Si el usuario root tiene contrasena, agregue -pSU_CLAVE despues de -u root.
set MYSQLDUMP=C:\xampp\mysql\bin\mysqldump.exe
set BASE=ies4_expedientes_v2
set DESTINO=%~dp0..\backups
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set FECHA=%%i
if not exist "%DESTINO%" mkdir "%DESTINO%"
"%MYSQLDUMP%" -u root --single-transaction --routines --triggers --default-character-set=utf8mb4 --result-file="%DESTINO%\respaldo_%FECHA%.sql" %BASE%
