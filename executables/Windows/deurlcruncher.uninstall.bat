@ECHO OFF

:: -- Edit bellow vvvv DeSOTA DEVELOPER EXAMPLe (Python - Tool): miniconda + pip pckgs + python cli script

:: USER PATH
:: %~dp0 = C:\users\[user]\Desota\Desota_Models\DeUrlCruncher\executables\Windows
for %%a in ("%~dp0..\..\..\..\..") do set "user_path=%%~fa"
for %%a in ("%~dp0\..\..\..\..\..\..") do set "test_path=%%~fa"
for %%a in ("%UserProfile%\..") do set "test1_path=%%~fa"

:: Model VARS
set model_name=DeUrlCruncher
set model_path_basepath=Desota\Desota_Models\%model_name%
set uninstaller_header=%model_name% Uninstaller - Sad to say goodbye ):

:: - Miniconda (virtual environment) Vars
set conda_basepath=Desota\Portables\miniconda3\condabin\conda.bat
set model_env_basepath=%model_path_basepath%\env




:: -- Edit bellow if you're felling lucky ;) -- https://youtu.be/5NV6Rdv1a3I

:: IPUT ARGS - /Q=Quietly
SET arg1=/Q
:: Start Runner Service?
IF "%1" EQU "" GOTO noarg1
IF %1 EQU %arg1% (
    SET arg1_bool=1
    GOTO yeasarg1
)
:noarg1
SET arg1_bool=0
:yeasarg1

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
IF "%test_path%" EQU "C:\Users" GOTO TEST_PASSED
IF "%test_path%" EQU "C:\users" GOTO TEST_PASSED
IF "%test_path%" EQU "c:\Users" GOTO TEST_PASSED
IF "%test_path%" EQU "c:\users" GOTO TEST_PASSED
IF "%test1_path%" EQU "C:\Users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "C:\users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "c:\Users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "c:\users" GOTO TEST1_PASSED
ECHO %fail%Error: Can't Resolve Request!%ansi_end%
ECHO %fail%DEV TIP: Run Command Without Admin Rights!%ansi_end%
PAUSE
exit
:TEST1_PASSED
set user_path=%UserProfile%
:TEST_PASSED
:: Model VARS
set model_path=%user_path%\%model_path_basepath%
:: - Miniconda (virtual environment) Vars
set conda_path=%user_path%\%conda_basepath%
set model_env=%user_path%\%model_env_basepath%


:: Copy File from future  deleted folder
:: - Current Path
:: %~dp0 = C:\Users\[username]Desota\Desota_Models\DeUrlCruncher\executables\windows
set SCRIPTPATH=%~dpnx0
for %%F in ("%SCRIPTPATH%") do set BASENAME=%%~nxF
IF "%SCRIPTPATH%" NEQ "%user_path%\%BASENAME%" (
    del %user_path%\%BASENAME% >NUL 2>NUL
    copy %SCRIPTPATH% %user_path%\%BASENAME%
    IF %arg1_bool% EQU 1 (
        start %user_path%\%BASENAME% /Q
    ) ELSE (
        start %user_path%\%BASENAME%
    )
    exit
)

IF %arg1_bool% EQU 1 (
    :: QUIET UNISTALL

    :: Delete pip pckgs
    ECHO %info_h1%Deleting pip packages%ansi_end%
    ECHO The packages from the following environment will be REMOVED:
    ECHO     Package Plan: %model_env%
    call %conda_path% remove --prefix %model_env% --all --force -y>NUL 2>NUL

    :: Delete Project Folder
	ECHO %info_h1%Deleting Project Folder%ansi_end%
    IF EXIST %model_path% rmdir /S /Q %model_path% >NUL 2>NUL
    GOTO EOF_UN
)

:: USER UNINSTALL

:: Delete pip pckgs
ECHO %info_h1%Deleting pip packages%ansi_end%
call %conda_path% remove --prefix %model_env% --all --force 

:: Delete Project Folder
ECHO %info_h1%Deleting Project Folder%ansi_end%
IF EXIST %model_path% rmdir /S %model_path%


:EOF_UN
:: Inform Uninstall Completed
IF EXIST %model_path% (
    ECHO %fail%%model_name% Uninstall Fail%ansi_end%
    PAUSE
) ELSE (
    ECHO %sucess%%model_name% Uninstalation Completed!%ansi_end%
    timeout 1 >NUL 2>NUL
)
IF %arg1_bool% EQU 1 (
    del %user_path%\%BASENAME% >NUL 2>NUL && exit
)
del %user_path%\%BASENAME% >NUL 2>NUL && PAUSE && exit