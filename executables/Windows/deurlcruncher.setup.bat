@ECHO OFF
:: Instalation VARS
set model_name=DeUrlCruncher
:: - Model GIT
set model_release=https://github.com/franciscomvargas/deurlcruncher/archive/refs/tags/v0.0.0.zip
:: - Model Path
:: %~dp0 = C:\Users\[username]Desota\Desota_Models\DeUrlCruncher\executables\windows
for %%a in ("%~dp0\..\..\..\..\..") do set "user_path=%%~fa"
for %%a in ("%~dp0\..\..\..\..\..\..") do set "test_path=%%~fa"
for %%a in ("%UserProfile%\..") do set "test1_path=%%~fa"


:: -- Edit bellow if you're felling lucky ;) -- https://youtu.be/5NV6Rdv1a3I

:: Program Installers
set miniconda64=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe
set miniconda32=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86.exe

:: IPUT ARGS - /startmodel="Start Model Service"
SET arg1=/startmodel
SET arg2=/debug
:: Start Runner Service?
IF "%1" EQU "" GOTO noarg1
IF %1 EQU %arg1% (
    SET arg1_bool=1
    GOTO yeasarg1
)
IF "%2" EQU "" GOTO noarg1
IF %2 EQU %arg1% (
    SET arg1_bool=1
    GOTO yeasarg1
)
:noarg1
SET arg1_bool=0
:yeasarg1
:: DEBUG
IF "%1" EQU "" GOTO noarg2
IF %1 EQU %arg2% (
    SET arg2_bool=1
    GOTO yeasarg2
)
IF "%2" EQU "" GOTO noarg2
IF %2 EQU %arg2% (
    SET arg2_bool=1
    GOTO yeasarg2
)
:noarg2
SET arg2_bool=0
:yeasarg2

:: .BAT ANSI Colored CLI
set header=
set info=
set sucess=
set fail=
set ansi_end=
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" GOTO set_ansi_colors
if "%version%" == "11.0" GOTO set_ansi_colors
GOTO end_ansi_colors
:set_ansi_colors
for /F %%a in ('echo prompt $E ^| cmd') do (
  set "ESC=%%a"
)
set header=%ESC%[4;95m
set info_h1=%ESC%[93m
set info_h2=%ESC%[33m
set sucess=%ESC%[7;32m
set fail=%ESC%[7;31m
set fail1=%ESC%[31m
set ansi_end=%ESC%[0m
:end_ansi_colors

ECHO %header%Welcome to %model_name% Setup!%ansi_end%

:: TEST PATH
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
set model_path=%user_path%\Desota\Desota_Models\%model_name%

:: Model Folder
:: DEV TIP: call powershell -command "Invoke-WebRequest -Uri %model_release% -OutFile %user_path%\%model_name%_release.zip" &&  tar -xzvf %user_path%\%model_name%_release.zip -C %model_path% --strip-components 1 && del %user_path%\%model_name%_release.zip
IF NOT EXIST %model_path% (
    ECHO %fail%Error: Model not installed correctly %ansi_end%
    ECHO %fail%CMD TIP: Install model with the following command:%ansi_end%
    ECHO     powershell -command "Invoke-WebRequest -Uri %model_release% -OutFile %user_path%\%model_name%_release.zip" ^&^&  tar -xzvf %user_path%\%model_name%_release.zip -C %model_path% --strip-components 1 ^&^& del %user_path%\%model_name%_release.zip
    PAUSE
    exit
)

:: Move to Project Folder
ECHO %info_h1%Step 1/3 - Move (cd) to Project Path%ansi_end%
call cd %model_path% >NUL 2>NUL

:: Install Conda Required
ECHO %info_h1%Step 2/3 - Install Miniconda for Project%ansi_end%
call mkdir %user_path%\Desota\Portables >NUL 2>NUL
IF NOT EXIST %user_path%\Desota\Portables\miniconda3\condabin\conda.bat goto installminiconda
goto skipinstallminiconda
:installminiconda
IF %PROCESSOR_ARCHITECTURE%==AMD64 powershell -command "Invoke-WebRequest -Uri %miniconda64% -OutFile %user_path%\miniconda_installer.exe" && start /B /WAIT %user_path%\miniconda_installer.exe /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=%user_path%\Desota\Portables\miniconda3 && del %user_path%\\miniconda_installer.exe && goto skipinstallminiconda
IF %PROCESSOR_ARCHITECTURE%==x86 powershell -command "Invoke-WebRequest -Uri %miniconda32% -OutFile %user_path%\miniconda_installer.exe" && start /B /WAIT %user_path%\miniconda_installer.exe /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=%model_path%Desota\Portables\miniconda3 && del %user_path%\\miniconda_installer.exe && && goto skipinstallminiconda
:skipinstallminiconda

:: SET Miniconda PATH
ECHO %info_h2%Creating Model Dedicated MiniConda Path...%ansi_end% 
set conda_path=%user_path%\Desota\Portables\miniconda3\condabin\conda_%model_name%.bat
IF EXIST %conda_path% (
    call del %conda_path%
)
call copy %user_path%\Desota\Portables\miniconda3\condabin\conda.bat %conda_path%

:: Create/Activate Conda Virtual Environment
ECHO %info_h2%Creating MiniConda Environment...%ansi_end% 
IF %arg2_bool% EQU 1 (
    call %conda_path% create --prefix ./env python=3.11 -y
) ELSE (
    call %conda_path% create --prefix ./env python=3.11 -y >NUL 2>NUL
)
IF %arg2_bool% EQU 1 (
    call %conda_path% activate ./env
) ELSE (
    call %conda_path% activate ./env >NUL 2>NUL
)
IF %arg2_bool% EQU 1 (
    call %conda_path% install pip -y
) ELSE (
    call %conda_path% install pip -y > NUL 2>NUL
)



:: Install required Libraries
ECHO %info_h1%Step 3/3 - Install Project Packages%ansi_end%
IF %arg2_bool% EQU 1 (
    call pip install -r requirements.txt
) ELSE (
    call pip install -r requirements.txt >NUL 2>NUL
    call pip freeze
)


:: MINICONDA ENV DEACTIVATE
call %conda_path% deactivate >NUL 2>NUL


:: Start Runner Service?
IF %arg1_bool% EQU 0 GOTO NOSTART
start /B /WAIT %model_start%
ECHO %sucess%Instalation Completed!%ansi_end%
ECHO %info_h2%model name  : %model_name%%ansi_end%
:: PAUSE FOR DEBUG
IF %arg2_bool% EQU 0 GOTO EOF_IN
PAUSE
GOTO EOF_IN

:NOSTART
ECHO %sucess%%model_name% Instalation Completed!%ansi_end%
ECHO %info_h2%model name  : %model_name%%ansi_end% 
:: PAUSE FOR DEBUG
IF %arg2_bool% EQU 0 GOTO EOF_IN
PAUSE
:EOF_IN
exit