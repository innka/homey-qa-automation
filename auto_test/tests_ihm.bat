@echo off
REM ============================================================
REM Lancement :
REM
REM Tous les tests IHM :
REM auto_test\tests_ihm.bat
REM
REM Seulement les tests US-07 :
REM auto_test\tests_ihm.bat us07
REM
REM Seulement les tests US-08 :
REM auto_test\tests_ihm.bat us08
REM ============================================================

REM Le dossier dans lequel se trouve ce fichier tests_ihm.bat
set "DOSSIER_SCRIPT=%~dp0"

REM Dossier contenant les tests Robot Framework
set "DOSSIER_TESTS=%DOSSIER_SCRIPT%IHM"

REM Dossier dans lequel les rapports seront enregistrés
set "DOSSIER_RESULTATS=%DOSSIER_SCRIPT%results\IHM"

REM Par défaut, on lance tous les tests
set "CHOIX=%~1"

if "%CHOIX%"=="" (
    set "CHOIX=all"
)

REM ============================================================
REM Lancement de tous les tests IHM
REM ============================================================

if /I "%CHOIX%"=="all" (
    echo.
    echo Lancement de tous les tests IHM...
    echo.

    robot --outputdir "%DOSSIER_RESULTATS%\all" "%DOSSIER_TESTS%"
    goto fin
)

REM ============================================================
REM Lancement des tests US-07
REM ============================================================

if /I "%CHOIX%"=="us07" (
    echo.
    echo Lancement des tests IHM de l'US-07...
    echo.

    robot --outputdir "%DOSSIER_RESULTATS%\US-07" "%DOSSIER_TESTS%\US-07"
    goto fin
)

REM ============================================================
REM Lancement des tests US-08
REM ============================================================

if /I "%CHOIX%"=="us08" (
    echo.
    echo Lancement des tests IHM de l'US-08...
    echo.

    robot --outputdir "%DOSSIER_RESULTATS%\US-08" "%DOSSIER_TESTS%\US-08"
    goto fin
)

REM ============================================================
REM Message si l'argument est incorrect
REM ============================================================

echo.
echo Erreur : choix inconnu "%CHOIX%".
echo.
echo Commandes disponibles :
echo auto_test\tests_ihm.bat
echo auto_test\tests_ihm.bat us07
echo auto_test\tests_ihm.bat us08
echo.

exit /b 1

:fin

REM On recupere le resultat retourne par Robot Framework
set "RESULTAT=%ERRORLEVEL%"
echo.

if "%RESULTAT%"=="0" (
    echo Tous les tests demandes se sont executes correctement.
) else (
    echo Un ou plusieurs tests ont echoue.
)

echo.
echo Les rapports sont disponibles dans :
echo %DOSSIER_RESULTATS%
echo.

exit /b %RESULTAT%