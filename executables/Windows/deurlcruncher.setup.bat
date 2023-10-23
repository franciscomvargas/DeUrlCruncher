@ECHO OFF

:: GET ADMIN > BEGIN
net session >NUL 2>NUL
IF %errorLevel% NEQ 0 (
	goto UACPrompt
) ELSE (
	goto gotAdmin
)
:UACPrompt
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params= %*
ECHO UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
cscript "%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B
:gotAdmin
:: GET ADMIN > END



:: -- Edit bellow vvvv DeSOTA DEVELOPER EXAMPLe (Python - Tool): miniconda + pip pckgs + python cli script

:: USER PATH
:: %~dp0 = C:\Users\[username]Desota\Desota_Models\DeUrlCruncher\executables\windows
for %%a in ("%~dp0\..\..\..\..\..") do set "user_path=%%~fa"
for %%a in ("%~dp0\..\..\..\..\..\..") do set "test_path=%%~fa"
for %%a in ("%UserProfile%\..") do set "test1_path=%%~fa"

:: Model VARS
set model_name=DeUrlCruncher
set model_path_basepath=Desota\Desota_Models\%model_name%
set python_main_basepath=%model_path_basepath%\main.py

:: - Model GIT
set model_release=https://github.com/franciscomvargas/deurlcruncher/archive/refs/tags/v0.0.0.zip

:: - Miniconda (virtual environment) Vars
set conda_basepath=\Desota\Portables\miniconda3\condabin\conda.bat
set model_env_basepath=%model_path_basepath%\env
set pip_reqs_basepath=%model_path_basepath%\requirements.txt



:: -- Edit bellow if you're felling lucky ;) -- https://youtu.be/5NV6Rdv1a3I

:: Program Installers
set miniconda64=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe
set miniconda32=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86.exe

:: IPUT ARGS
:: /manualstart :: Start Model Service Manually: %UserProfile%\Desota\Desota_Models\DeScraper\executables\Windows\descraper.start.bat
SET arg1=/manualstart
:: /debug :: Log everything and require USER interaction
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

:: GET USER PATH

IF "%test_path%" EQU "C:\Users" GOTO TEST_PASSED
IF "%test_path%" EQU "C:\users" GOTO TEST_PASSED
IF "%test_path%" EQU "c:\Users" GOTO TEST_PASSED
IF "%test_path%" EQU "c:\users" GOTO TEST_PASSED
IF "%test1_path%" EQU "C:\Users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "C:\users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "c:\Users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "c:\users" GOTO TEST1_PASSED
ECHO %fail%Error: Can't Resolve Request!%ansi_end%
ECHO %fail%[ DEV TIP ] Run Command Without Admin Rights!%ansi_end%
PAUSE
exit
:TEST1_PASSED
set user_path=%UserProfile%
:TEST_PASSED
:: Model VARS
set model_path=%user_path%\%model_path_basepath%
set python_main=%user_path%\%python_main_basepath%
:: Miniconda (virtual environment) Vars
set conda_path=%user_path%\%conda_basepath%
set model_env=%user_path%\%model_env_basepath%
set pip_reqs=%user_path%\%pip_reqs_basepath%

:: Model Folder
:: DEV TIP: call powershell -command "Invoke-WebRequest -Uri %model_release% -OutFile %user_path%\%model_name%_release.zip" &&  tar -xzvf %user_path%\%model_name%_release.zip -C %model_path% --strip-components 1 && del %user_path%\%model_name%_release.zip
IF NOT EXIST %model_path% (
    ECHO %fail%Error: Model not installed correctly %ansi_end%
    ECHO %fail1%[ CMD TIP ] Download Release with this command:%ansi_end%
    ECHO     IF EXIST %model_path% ^( rmdir /S /Q %model_path% ^) ELSE ^( ECHO New Install! ^) ^&^& mkdir %model_path% ^&^& powershell -command "Invoke-WebRequest -Uri %model_release% -OutFile %user_path%\%model_name%_release.zip" ^&^&  tar -xzvf %user_path%\%model_name%_release.zip -C %model_path% --strip-components 1 ^&^& del %user_path%\%model_name%_release.zip
    ECHO  %ESC%P
    PAUSE
    exit
)

:: Move to Project Folder
ECHO %info_h1%Step 1/3 - Move (cd) to Project Path%ansi_end%
call cd %model_path% >NUL 2>NUL

:: Install Conda Required
ECHO %info_h1%Step 2/3 - Install Miniconda for Project%ansi_end%
call mkdir %user_path%\Desota\Portables >NUL 2>NUL
IF NOT EXIST %conda_path% goto installminiconda
goto skipinstallminiconda
:installminiconda
IF %PROCESSOR_ARCHITECTURE%==AMD64 powershell -command "Invoke-WebRequest -Uri %miniconda64% -OutFile %user_path%\miniconda_installer.exe" && start /B /WAIT %user_path%\miniconda_installer.exe /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=%user_path%\Desota\Portables\miniconda3 && del %user_path%\miniconda_installer.exe && goto skipinstallminiconda
IF %PROCESSOR_ARCHITECTURE%==x86 powershell -command "Invoke-WebRequest -Uri %miniconda32% -OutFile %user_path%\miniconda_installer.exe" && start /B /WAIT %user_path%\miniconda_installer.exe /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=%user_path%\Desota\Portables\miniconda3 && del %user_path%\miniconda_installer.exe && && goto skipinstallminiconda
:skipinstallminiconda

:: Create/Activate Conda Virtual Environment
ECHO %info_h2%Creating MiniConda Environment...%ansi_end% 
IF %arg2_bool% EQU 1 GOTO noisy_conda

:: QUIET SETUP

call %conda_path% create --prefix %model_env% python=3.11 -y >NUL 2>NUL
call %conda_path% activate %model_env% >NUL 2>NUL
call %conda_path% install pip -y > NUL 2>NUL
GOTO eo_conda

:: USER SETUP
:noisy_conda
call %conda_path% create --prefix %model_env% python=3.11 -y
call %conda_path% activate %model_env%
call %conda_path% install pip -y

:eo_conda


:: Install required Libraries
ECHO %info_h1%Step 3/3 - Install Project Packages%ansi_end%
IF %arg2_bool% EQU 1 (
    call pip install -r %pip_reqs%
) ELSE (
    call pip install -r %pip_reqs% >NUL 2>NUL
    call pip freeze
)


:: MINICONDA ENV DEACTIVATE
call %conda_path% deactivate >NUL 2>NUL


:: Start Runner Service?
IF %arg1_bool% EQU 0 GOTO NOSTART
start %model_env%\python %python_main%
ECHO %sucess%Instalation Completed!%ansi_end%
ECHO %info_h2%model name  : %model_name%%ansi_end%
:: PAUSE FOR DEBUG
IF %arg2_bool% EQU 0 exit
PAUSE
exit

:NOSTART
ECHO %sucess%%model_name% Instalation Completed!%ansi_end%
ECHO %info_h2%model name  : %model_name%%ansi_end% 
:: PAUSE FOR DEBUG
IF %arg2_bool% EQU 0 exit
PAUSE
exit