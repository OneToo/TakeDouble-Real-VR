@ECHO OFF

SET pshell=powershell
WHERE /Q %pshell%
IF NOT ERRORLEVEL 1 GOTO havepshell
SET pshell=%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell
IF EXIST %pshell%.exe GOTO havepshell
ECHO ERROR: PowerShell is needed for this batch file, but it cannot be detected
ECHO        on your system (it should be preinstalled on Windows 10 since version
ECHO        1607). You should either check your Windows installation or go to this
ECHO        Microsoft page and install PowerShell yourself:
ECHO        https://tinyurl.com/y85wsdr4
ECHO(
GOTO abort

:havepshell
IF "%1"=="as_admin" GOTO isadmin
FOR /F "tokens=* USEBACKQ" %%F IN (`%pshell% "[Environment]::GetFolderPath('Personal')"`) DO SET doc=%%F\
FOR /F "tokens=* USEBACKQ" %%F IN (`%pshell% "(new-object -COM Shell.Application).Namespace(0x05).Self.Path"`) DO SET doc1=%%F\
SET "doc2=%USERPROFILE%\Documents\"
IF "%doc1%"=="\" SET "doc1=%doc2%"
IF "%doc%"=="\" SET "doc=%doc1%"
SET "loc=%LOCALAPPDATA%"
SET "app=%APPDATA%"

IF NOT EXIST RealRepo\elevate.exe GOTO badextract
RealRepo\elevate -c %0 as_admin "%doc%" "%doc1%" "%doc2%" "%loc%" "%app%"
IF NOT ERRORLEVEL 1 GOTO exitnow
ECHO ERROR: The installer needs administrative privileges to complete. Please
ECHO        make sure to answer Yes at the User Account Control (UAC) prompt.
ECHO        After the installation completes successfully, it will no longer
ECHO        be necessary to run the game or the mod as admin.
ECHO(
GOTO abort

:isadmin
SET doc=%2
SET doc1=%3
SET doc2=%4
SET loc=%5
SET app=%6
SET "doc=%doc:"=%"
SET "doc1=%doc1:"=%"
SET "doc2=%doc2:"=%"
SET "loc=%loc:"=%"
SET "app=%app:"=%"

SET base=%~dp0
CD /D %base%

IF EXIST RealRepo GOTO haverepo
:badextract
ECHO ERROR: Mod installation files not found. When unzipping the mod archive,
ECHO        please make sure to overwrite existing files and to use folder
ECHO        names (preserve the zip folder structure).
ECHO(
GOTO abort

:haverepo
IF NOT EXIST RealVR*.ini GOTO noini
ECHO R.E.A.L. VR settings were found in the game folder,
ECHO presumably from a previous installation of the mod.
CHOICE /C KD /M "Do you want to (K)eep or (D)elete them?"
IF ERRORLEVEL 3 GOTO abort
IF NOT ERRORLEVEL 1 GOTO abort
IF ERRORLEVEL 2 DEL /F /Q RealVR*.ini
ECHO(
ECHO(

:noini
IF EXIST RDR2.exe GOTO installRDR2
IF EXIST mafiadefinitiveedition.exe GOTO installMDE1
IF EXIST "Mafia II Definitive Edition.exe" GOTO installMDE2
IF EXIST mafia3definitiveedition.exe GOTO installMDE3
IF EXIST HorizonZeroDawn.exe GOTO installHZD
IF EXIST Cyberpunk2077.exe GOTO installCP2077
IF EXIST eldenring.exe GOTO installELDEN
IF EXIST DarkSoulsRemastered.exe GOTO installDSR
ECHO ERROR: This folder does not seem to belong to any of the supported games.
ECHO        Please make sure that the mod zip archive is extracted to the very
ECHO        same folder where the main game executable is found, and not for
ECHO        example into a subfolder.
ECHO(
GOTO abort


:installRDR2
ECHO *********************************************
ECHO * R.E.A.L. VR mod for Red Dead Redemption 2 *
ECHO *********************************************
ECHO(
CHOICE /C UHMLO /M "Select (U)ltra, (H)igh, (M)edium, (L)ow or HUB (O)ptimized config"
IF ERRORLEVEL 6 GOTO abort
IF NOT ERRORLEVEL 1 GOTO abort
IF ERRORLEVEL 1 SET cfg=1ultra
IF ERRORLEVEL 2 SET cfg=2high
IF ERRORLEVEL 3 SET cfg=3medium
IF ERRORLEVEL 4 SET cfg=4low
IF ERRORLEVEL 5 SET cfg=5hub

ECHO Fixing folder permissions...
ICACLS . /GRANT *S-1-5-32-545:(OI)(CI)F /T /Q

IF EXIST RDR2 RMDIR /S /Q RDR2

ECHO Copying game specific files...
COPY /Y RealRepo\RDR2\* .
COPY /Y RealRepo\RealVR64.dll .
IF NOT EXIST RealVR.ini COPY /Y RealRepo\RealVR.ini .

ECHO Configuring Vulkan layers...
%pshell% "Remove-ItemProperty -Path HKCU:\SOFTWARE\Khronos\Vulkan\ImplicitLayers -Name *RealVR64.json" 2>nul
%pshell% "Remove-ItemProperty -Path HKLM:\SOFTWARE\Khronos\Vulkan\ImplicitLayers -Name *RealVR64.json"
REG ADD HKLM\SOFTWARE\Khronos\Vulkan\ImplicitLayers /V "%base%RealVR64.json" /T REG_DWORD /D 0 /F

ECHO Installing graphics settings preset...
SET sub=Rockstar Games\Red Dead Redemption 2\Settings\
IF NOT EXIST "%doc%%sub%" IF EXIST "%doc1%%sub%" SET "doc=%doc1%"
IF NOT EXIST "%doc%%sub%" IF EXIST "%doc2%%sub%" SET "doc=%doc2%"
SET "dst=%doc%%sub%"
IF EXIST "%dst%" (
    IF EXIST "%dst%system.xml" (
        IF NOT EXIST "%dst%system_ori.xml" REN "%dst%system.xml" system_ori.xml
    ) ELSE (
        ECHO WARNING: Unable to find previous graphics settings file
        ECHO          "%dst%system.xml"
    )
) ELSE (
    ECHO WARNING: The game appears to never have been run. Creating new settings file
    ECHO          "%dst%system.xml"
    MKDIR "%dst%"
)
COPY /Y "RealRepo\RDR2\Settings\system_%cfg%.xml" "%dst%system.xml"

ECHO Cleaning up...
IF EXIST RealRepo\MDE1 RMDIR /S /Q RealRepo\MDE1
IF EXIST RealRepo\MDE2 RMDIR /S /Q RealRepo\MDE2
IF EXIST RealRepo\MDE3 RMDIR /S /Q RealRepo\MDE3
IF EXIST RealRepo\HZD RMDIR /S /Q RealRepo\HZD
IF EXIST RealRepo\CP2077 RMDIR /S /Q RealRepo\CP2077
IF EXIST RealRepo\ELDEN RMDIR /S /Q RealRepo\ELDEN
IF EXIST RealRepo\DSR RMDIR /S /Q RealRepo\DSR
GOTO finish


:installMDE1
ECHO *************************************************
ECHO * R.E.A.L. VR mod for Mafia: Definitive Edition *
ECHO *************************************************
ECHO(
CHOICE /C YN /M "Do you want to install the on-foot 1st person camera? (Y/N)"
IF ERRORLEVEL 3 GOTO abort
IF NOT ERRORLEVEL 1 GOTO abort
IF ERRORLEVEL 1 SET first=yes
IF ERRORLEVEL 2 SET first=no

ECHO Fixing folder permissions...
ICACLS . /GRANT *S-1-5-32-545:(OI)(CI)F /T /Q

ECHO Installing graphics settings preset...
SET sub=My Games\Mafia Definitive Edition\
IF NOT EXIST "%doc%%sub%" IF EXIST "%doc1%%sub%" SET "doc=%doc1%"
IF NOT EXIST "%doc%%sub%" IF EXIST "%doc2%%sub%" SET "doc=%doc2%"
SET "dst=%doc%%sub%"
SET haveprofile=no
IF NOT EXIST "%dst%" GOTO checkMDE1profile
FOR /F "delims=" %%D IN ('DIR /AD /B "%dst%Data"') DO (
    COPY /Y "RealRepo\MDE1\settings\profile_videosettings.pf" "%dst%Data\%%D\profiles\temporaryprofile"
    SET haveprofile=yes
)
:checkMDE1profile
IF %haveprofile%==no GOTO neverrun
COPY /Y "RealRepo\MDE1\settings\videoconfig.cfg" "%dst%Saves"
COPY /Y "RealRepo\MDE1\settings\launcconfig.cfg" "%dst%Saves"

ECHO Copying game specific files...
XCOPY /E /I /Q /Y RealRepo\MDE1\sds_retail sds_retail
IF %first%==yes COPY /Y RealRepo\MDE1\1st_person\tables.sds sds_retail\tables
COPY /Y RealRepo\RealVR64.dll dxgi.dll
IF NOT EXIST RealVR.ini COPY /Y RealRepo\RealVR.ini .

ECHO Cleaning up...
IF EXIST RealRepo\RDR2 RMDIR /S /Q RealRepo\RDR2
IF EXIST RealRepo\MDE2 RMDIR /S /Q RealRepo\MDE2
IF EXIST RealRepo\MDE3 RMDIR /S /Q RealRepo\MDE3
IF EXIST RealRepo\HZD RMDIR /S /Q RealRepo\HZD
IF EXIST RealRepo\CP2077 RMDIR /S /Q RealRepo\CP2077
IF EXIST RealRepo\ELDEN RMDIR /S /Q RealRepo\ELDEN
IF EXIST RealRepo\DSR RMDIR /S /Q RealRepo\DSR
GOTO finish


:installMDE2
ECHO ****************************************************
ECHO * R.E.A.L. VR mod for Mafia II: Definitive Edition *
ECHO ****************************************************
ECHO(

ECHO Fixing folder permissions...
ICACLS . /GRANT *S-1-5-32-545:(OI)(CI)F /T /Q

ECHO Installing graphics settings preset...
SET sub=My Games\Mafia II Definitive Edition\
IF NOT EXIST "%doc%%sub%" IF EXIST "%doc1%%sub%" SET "doc=%doc1%"
IF NOT EXIST "%doc%%sub%" IF EXIST "%doc2%%sub%" SET "doc=%doc2%"
SET "dst=%doc%%sub%"
SET haveprofile=no
IF NOT EXIST "%dst%" GOTO checkMDE2profile
FOR /F "delims=" %%D IN ('DIR /AD /B "%dst%Data\profiles"') DO (
    COPY /Y "RealRepo\MDE2\settings\settings.xml" "%dst%Data\profiles\%%D"
    SET haveprofile=yes
)
:checkMDE2profile
IF %haveprofile%==no GOTO neverrun

ECHO Copying game specific files...
XCOPY /E /I /Q /Y RealRepo\MDE2\sds sds
XCOPY /E /I /Q /Y RealRepo\MDE2\dlcs dlcs
COPY /Y RealRepo\RealVR64.dll dxgi.dll
IF NOT EXIST RealVR.ini COPY /Y RealRepo\RealVR.ini .

ECHO Cleaning up...
IF EXIST RealRepo\RDR2 RMDIR /S /Q RealRepo\RDR2
IF EXIST RealRepo\MDE1 RMDIR /S /Q RealRepo\MDE1
IF EXIST RealRepo\MDE3 RMDIR /S /Q RealRepo\MDE3
IF EXIST RealRepo\HZD RMDIR /S /Q RealRepo\HZD
IF EXIST RealRepo\CP2077 RMDIR /S /Q RealRepo\CP2077
IF EXIST RealRepo\ELDEN RMDIR /S /Q RealRepo\ELDEN
IF EXIST RealRepo\DSR RMDIR /S /Q RealRepo\DSR
GOTO finish


:installMDE3
ECHO *****************************************************
ECHO * R.E.A.L. VR mod for Mafia III: Definitive Edition *
ECHO *****************************************************
ECHO(
CHOICE /C YN /M "Do you want to install the on-foot 1st person camera? (Y/N)"
IF ERRORLEVEL 3 GOTO abort
IF NOT ERRORLEVEL 1 GOTO abort
IF ERRORLEVEL 1 SET first=yes
IF ERRORLEVEL 2 SET first=no

ECHO Fixing folder permissions...
ICACLS . /GRANT *S-1-5-32-545:(OI)(CI)F /T /Q

ECHO Installing graphics settings preset...
SET sub=\2K Games\Mafia III\
SET "dst=%loc%%sub%"
SET haveprofile=no
IF NOT EXIST "%dst%" GOTO checkMDE3profile
FOR /F "delims=" %%D IN ('DIR /AD /B "%dst%Data"') DO (
    COPY /Y "RealRepo\MDE3\settings\profile_videosettings.pf" "%dst%Data\%%D\profiles\temporaryprofile"
    SET haveprofile=yes
)
:checkMDE3profile
IF %haveprofile%==no GOTO neverrun
COPY /Y "RealRepo\MDE3\settings\videoconfig.cfg" "%dst%Saves"
COPY /Y "RealRepo\MDE3\settings\launcconfig.cfg" "%dst%Saves"

ECHO Copying game specific files...
XCOPY /E /I /Q /Y RealRepo\MDE3\sds_retail sds_retail
XCOPY /E /I /Q /Y RealRepo\MDE3\reshade .
IF %first%==yes COPY /Y RealRepo\MDE3\1st_person\tables.sds sds_retail\tables
COPY /Y RealRepo\RealVR64.dll dxgi.dll
IF NOT EXIST RealVR.ini COPY /Y RealRepo\RealVR.ini .

ECHO Cleaning up...
IF EXIST RealRepo\RDR2 RMDIR /S /Q RealRepo\RDR2
IF EXIST RealRepo\MDE1 RMDIR /S /Q RealRepo\MDE1
IF EXIST RealRepo\MDE2 RMDIR /S /Q RealRepo\MDE2
IF EXIST RealRepo\HZD RMDIR /S /Q RealRepo\HZD
IF EXIST RealRepo\CP2077 RMDIR /S /Q RealRepo\CP2077
IF EXIST RealRepo\ELDEN RMDIR /S /Q RealRepo\ELDEN
IF EXIST RealRepo\DSR RMDIR /S /Q RealRepo\DSR
GOTO finish


:installHZD
ECHO ******************************************
ECHO * R.E.A.L. VR mod for Horizon: Zero Dawn *
ECHO ******************************************
ECHO(

ECHO Fixing folder permissions...
ICACLS . /GRANT *S-1-5-32-545:(OI)(CI)F /T /Q

ECHO Installing graphics settings preset...
SET sub=Horizon Zero Dawn\Saved Game\profile\
IF NOT EXIST "%doc%%sub%" IF EXIST "%doc1%%sub%" SET "doc=%doc1%"
IF NOT EXIST "%doc%%sub%" IF EXIST "%doc2%%sub%" SET "doc=%doc2%"
SET "dst=%doc%%sub%"
IF EXIST "%dst%" (
    IF EXIST "%dst%graphicsconfig.ini" (
        IF NOT EXIST "%dst%graphicsconfig_ori.ini" REN "%dst%graphicsconfig.ini" graphicsconfig_ori.ini
    ) ELSE (
        ECHO WARNING: Unable to find previous graphics settings file
        ECHO          "%dst%graphicsconfig.ini"
    )
) ELSE GOTO neverrun
COPY /Y "RealRepo\HZD\settings\graphicsconfig.ini" "%dst%"

ECHO Copying game specific files...
COPY /Y RealRepo\RealVR64.dll dxgi.dll
IF NOT EXIST RealVR.ini COPY /Y RealRepo\RealVR.ini .

ECHO Cleaning up...
IF EXIST RealRepo\RDR2 RMDIR /S /Q RealRepo\RDR2
IF EXIST RealRepo\MDE1 RMDIR /S /Q RealRepo\MDE1
IF EXIST RealRepo\MDE2 RMDIR /S /Q RealRepo\MDE2
IF EXIST RealRepo\MDE3 RMDIR /S /Q RealRepo\MDE3
IF EXIST RealRepo\CP2077 RMDIR /S /Q RealRepo\CP2077
IF EXIST RealRepo\ELDEN RMDIR /S /Q RealRepo\ELDEN
IF EXIST RealRepo\DSR RMDIR /S /Q RealRepo\DSR
GOTO finish


:installCP2077
ECHO **************************************
ECHO * R.E.A.L. VR mod for Cyberpunk 2077 *
ECHO **************************************
ECHO(

ECHO Fixing folder permissions...
ICACLS . /GRANT *S-1-5-32-545:(OI)(CI)F /T /Q

ECHO Installing graphics settings preset...
SET sub=\CD Projekt Red\Cyberpunk 2077\
SET "dst=%loc%%sub%"
IF EXIST "%dst%UserSettings.json" (
    IF NOT EXIST "%dst%UserSettings_ori.json" COPY /Y "%dst%UserSettings.json" "%dst%UserSettings_ori.json"
) ELSE GOTO neverrun
REN "%dst%UserSettings.json" UserSettings_src.json
RealRepo\ReplaceJSON "%dst%UserSettings_src.json" RealRepo\CP2077\settings\option.replace "%dst%UserSettings.json"
DEL /F /Q "%dst%UserSettings_src.json"

ECHO Copying game specific files...
COPY /Y RealRepo\RealVR64.dll dxgi.dll
IF NOT EXIST RealVR.ini COPY /Y RealRepo\RealVR.ini .

ECHO Cleaning up...
IF EXIST RealRepo\RDR2 RMDIR /S /Q RealRepo\RDR2
IF EXIST RealRepo\MDE1 RMDIR /S /Q RealRepo\MDE1
IF EXIST RealRepo\MDE2 RMDIR /S /Q RealRepo\MDE2
IF EXIST RealRepo\MDE3 RMDIR /S /Q RealRepo\MDE3
IF EXIST RealRepo\HZD RMDIR /S /Q RealRepo\HZD
IF EXIST RealRepo\ELDEN RMDIR /S /Q RealRepo\ELDEN
IF EXIST RealRepo\DSR RMDIR /S /Q RealRepo\DSR
GOTO finish


:installELDEN
ECHO **********************************
ECHO * R.E.A.L. VR mod for Elden Ring *
ECHO **********************************
ECHO(
CHOICE /C UHML /M "Select (U)ltra, (H)igh, (M)edium or (L)ow config"
IF ERRORLEVEL 5 GOTO abort
IF NOT ERRORLEVEL 1 GOTO abort
IF ERRORLEVEL 1 SET cfg=1ultra
IF ERRORLEVEL 2 SET cfg=2high
IF ERRORLEVEL 3 SET cfg=3medium
IF ERRORLEVEL 4 SET cfg=4low

ECHO Fixing folder permissions...
ICACLS . /GRANT *S-1-5-32-545:(OI)(CI)F /T /Q

ECHO Installing graphics settings preset...
SET sub=\EldenRing\
SET "dst=%app%%sub%"
IF EXIST "%dst%GraphicsConfig.xml" (
    IF NOT EXIST "%dst%GraphicsConfig_ori.xml" COPY /Y "%dst%GraphicsConfig.xml" "%dst%GraphicsConfig_ori.xml"
) ELSE GOTO neverrun
COPY /Y "RealRepo\ELDEN\Settings\GraphicsConfig_%cfg%.xml" "%dst%GraphicsConfig.xml"

ECHO Copying game specific files...
COPY /Y RealRepo\ELDEN\BackupSaves.bat RealRepo
FOR /F "USEBACKQ" %%F IN ('start_protected_game.exe') DO SET filesize=%%~zF
if %filesize% GTR 1048576 (
    IF EXIST start_protected_game_ori.exe DEL /F /Q start_protected_game_ori.exe
    REN start_protected_game.exe start_protected_game_ori.exe
    COPY /Y RealRepo\ELDEN\start_protected_game.exe .
)
COPY /Y RealRepo\RealVR64.dll .
IF NOT EXIST RealVR.ini COPY /Y RealRepo\RealVR.ini .

ECHO Cleaning up...
IF EXIST RealRepo\RDR2 RMDIR /S /Q RealRepo\RDR2
IF EXIST RealRepo\MDE1 RMDIR /S /Q RealRepo\MDE1
IF EXIST RealRepo\MDE2 RMDIR /S /Q RealRepo\MDE2
IF EXIST RealRepo\MDE3 RMDIR /S /Q RealRepo\MDE3
IF EXIST RealRepo\HZD RMDIR /S /Q RealRepo\HZD
IF EXIST RealRepo\CP2077 RMDIR /S /Q RealRepo\CP2077
IF EXIST RealRepo\DSR RMDIR /S /Q RealRepo\DSR
GOTO finish


:installDSR
ECHO **********************************************
ECHO * R.E.A.L. VR mod for Dark Souls: Remastered *
ECHO **********************************************
ECHO(

ECHO Fixing folder permissions...
ICACLS . /GRANT *S-1-5-32-545:(OI)(CI)F /T /Q

ECHO Installing graphics settings preset...
SET sub=\FromSoftware\NBGI\DarkSouls\
SET "dst=%loc%%sub%"
IF EXIST "%dst%DarkSouls.ini" (
    IF NOT EXIST "%dst%DarkSouls_ori.ini" COPY /Y "%dst%DarkSouls.ini" "%dst%DarkSouls_ori.ini"
) ELSE GOTO neverrun
COPY /Y "RealRepo\DSR\Settings\DarkSouls.ini" "%dst%DarkSouls.ini"

ECHO Copying game specific files...
COPY /Y RealRepo\DSR\BackupSaves.bat RealRepo
COPY /Y RealRepo\RealVR64.dll dxgi.dll
IF NOT EXIST RealVR.ini COPY /Y RealRepo\RealVR.ini .

ECHO Cleaning up...
IF EXIST RealRepo\RDR2 RMDIR /S /Q RealRepo\RDR2
IF EXIST RealRepo\MDE1 RMDIR /S /Q RealRepo\MDE1
IF EXIST RealRepo\MDE2 RMDIR /S /Q RealRepo\MDE2
IF EXIST RealRepo\MDE3 RMDIR /S /Q RealRepo\MDE3
IF EXIST RealRepo\HZD RMDIR /S /Q RealRepo\HZD
IF EXIST RealRepo\CP2077 RMDIR /S /Q RealRepo\CP2077
IF EXIST RealRepo\ELDEN RMDIR /S /Q RealRepo\ELDEN
GOTO finish


:neverrun
ECHO(
ECHO ERROR: The game appears to never have been run. Run the game at least
ECHO        once to create your user profile, then quit it and try installing
ECHO        the mod again.
ECHO(
:abort
ECHO Aborting RealConfig
GOTO end
:finish
ECHO All done!
:end
PAUSE
:exitnow
