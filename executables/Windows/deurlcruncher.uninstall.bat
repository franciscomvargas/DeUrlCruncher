@ECHO OFF
:: Uninstalation VARS
set model_name=Desota/DeUrlCruncher
set uninstaller_header=DeUrlCruncher Uninstaller - Sad to say goodbye ):
:: - User Path
:: %~dp0 = C:\users\[user]\Desota\Desota_Models\DeScraper\executables\Windows
for %%a in ("%~dp0..\..\..\..\..") do set "root_path=%%~fa"
:: - Model Path
for %%a in ("%~dp0..\..") do set "model_path=%%~fa"
:: - NSSM Path

:: -- Edit bellow if you're felling lucky ;) -- https://youtu.be/5NV6Rdv1a3I

:: IPUT ARGS - /Q=Quietly
SET arg1=/Q

:: - .bat ANSI Colored CLI
set header=
set info=
set sucess=
set fail=
set ansi_end=
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" GOTO set_ansi_colors_un
if "%version%" == "11.0" GOTO set_ansi_colors_un
GOTO end_ansi_colors_un
:set_ansi_colors_un
for /F %%a in ('echo prompt $E ^| cmd') do (
  set "ESC=%%a"
)
set header=%ESC%[4;95m
set info_h1=%ESC%[93m
set info_h2=%ESC%[33m
set sucess=%ESC%[7;32m
set fail=%ESC%[7;31m
set ansi_end=%ESC%[0m
:end_ansi_colors_un

ECHO %header%%uninstaller_header%%ansi_end%
ECHO    model name  : %model_name%

IF "%1" EQU "" GOTO noargs
IF %1 EQU /Q (
    :: Delete Project Folder
	ECHO %info_h1%Deleting Project Folder%ansi_end%
    IF EXIST %model_path% rmdir /S /Q %model_path% >NUL 2>NUL
    GOTO EOF_UN
)

:noargs
:: Delete Project Folder
IF EXIST %model_path% (
	ECHO %info_h1%Deleting Project Folder%ansi_end%
    rmdir /S %model_path%
    GOTO EOF_UN
)

:EOF_UN
:: Inform Uninstall Completed
IF EXIST %model_path% (
    ECHO %fail%%model_name% Uninstall Fail%ansi_end%
    PAUSE
) ELSE (
    ECHO %sucess%%model_name% Uninstalation Completed!%ansi_end%
    timeout 1 >NUL 2>NUL
)
exit