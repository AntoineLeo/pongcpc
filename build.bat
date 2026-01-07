@echo off
echo Compilation de pong.asm avec Overwrite...
.\rasm_x64.exe pong.asm -eo
if %errorlevel% neq 0 (
    echo Echec de la compilation! Vérifiez que le fichier pong.dsk n'est pas ouvert dans l'emulateur.
    pause
    exit /b %errorlevel%
)
echo Succes! Vous pouvez recharger pong.dsk (File -> Drive A -> Eject / Insert)
