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

:: GET USER PATH
IF "%test1_path%" EQU "C:\Users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "C:\users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "c:\Users" GOTO TEST1_PASSED
IF "%test1_path%" EQU "c:\users" GOTO TEST1_PASSED

IF "%test_path%" EQU "C:\Users" GOTO TEST_PASSED
IF "%test_path%" EQU "C:\users" GOTO TEST_PASSED
IF "%test_path%" EQU "c:\Users" GOTO TEST_PASSED
IF "%test_path%" EQU "c:\users" GOTO TEST_PASSED

ECHO Error: Can't Resolve Request!
ECHO [ DEV TIP ] Run Command Without Admin Rights!
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
    ECHO Error: Model not installed correctly 
    ECHO [ CMD TIP ] Download Release with this command:
    ECHO     IF EXIST %model_path% ^( rmdir /S /Q %model_path% ^) ELSE ^( ECHO New Install! ^) ^&^& mkdir %model_path% ^&^& powershell -command "Invoke-WebRequest -Uri %model_release% -OutFile %user_path%\%model_name%_release.zip" ^&^&  tar -xzvf %user_path%\%model_name%_release.zip -C %model_path% --strip-components 1 ^&^& del %user_path%\%model_name%_release.zip
    ECHO  %ESC%P
    PAUSE
    exit
)

:: Move to Project Folder
call cd %model_path% >NUL 2>NUL

:: Activate Conda Virtual Environment
ECHO Activating MiniConda Environment...
call %conda_path% activate %model_env%
call %conda_path% install pip -y


:: Install required Libraries
ECHO.
ECHO Install Project Packages
call pip install -r %pip_reqs% --compile --no-cache-dir

:: MINICONDA ENV DEACTIVATE
call %conda_path% deactivate >NUL 2>NUL

exit