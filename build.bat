@echo off
setlocal EnableExtensions
cd /d "%~dp0"
where git >nul 2>nul || exit /b 1
where cmake >nul 2>nul || exit /b 1
set "ROOT=%~dp0BestClient-source"
if not exist "%ROOT%\.git" git clone --recurse-submodules https://github.com/BestProjectTeam/BestClient.git "%ROOT%" || exit /b 1
git -C "%ROOT%" diff --quiet || exit /b 1
git -C "%ROOT%" fetch origin b357556f8c7817ca7220a8c21e4eb05f7dc492af || exit /b 1
git -C "%ROOT%" checkout --detach b357556f8c7817ca7220a8c21e4eb05f7dc492af || exit /b 1
git -C "%ROOT%" apply --check "%~dp0PastaClient.patch" || exit /b 1
git -C "%ROOT%" apply "%~dp0PastaClient.patch" || exit /b 1
git -C "%ROOT%" submodule update --init --recursive || exit /b 1
if not exist "%ROOT%\data\PastaClient" mkdir "%ROOT%\data\PastaClient"
copy /y "%~dp0data\PastaClient\gui_logo.png" "%ROOT%\data\PastaClient\gui_logo.png" >nul || exit /b 1
cmake -S "%ROOT%" -B "%ROOT%\build" -G "Visual Studio 17 2022" -A x64 -DCLIENT_EXECUTABLE=PastaClient -DDEV=OFF -DVULKAN=OFF || exit /b 1
cmake --build "%ROOT%\build" --config Release --target game-client --parallel 4 || exit /b 1
echo PastaClient.exe compiled
