@ECHO OFF

SET COMPOSE_FILE_PATH=.\docker-compose.yml

echo Docker compose file: %COMPOSE_FILE_PATH%

SET PARENT_FOLDER=
  
IF [%1]==[] (
    echo "Usage: %0 {build|start|stop|purge|tail}"
    GOTO END
)

IF %1==build (
	CALL :buildImages
    GOTO END
)

IF %1==start (
    CALL :init
    CALL :launch
    CALL :tail
    GOTO END
)

IF %1==stop (
    CALL :down
    GOTO END
)

IF %1==purge (
    CALL :init
    CALL:down
    CALL:purge
    GOTO END
)

IF %1==purgeAll (
    CALL :init
    CALL:down
    CALL:purgeAll
    GOTO END
)

IF %1==tail (
    CALL :tail
    GOTO END
)

:init
  set FULL_PATH=%~dp0
  set FULL_PATH=%FULL_PATH:~1,-1%
  for %%i in ("%FULL_PATH%") do set "PARENT_FOLDER=%%~ni"
  echo PARENT_FOLDER: %PARENT_FOLDER%

:END
EXIT /B %ERRORLEVEL%


:buildImages
    docker-compose -f "%COMPOSE_FILE_PATH%" build --no-cache
EXIT /B 0

:launch
    :Create volumes when external volumes are in use.
    :docker volume create acs-volume
    :docker volume create db-volume
    :docker volume create ass-volume
    docker-compose -f "%COMPOSE_FILE_PATH%" up --build	
	EXIT /B 0


:down
    if exist "%COMPOSE_FILE_PATH%" (
        docker-compose -f "%COMPOSE_FILE_PATH%" down
    )
EXIT /B 0

:tail
    docker-compose -f "%COMPOSE_FILE_PATH%" logs -f
EXIT /B 0

:purge	
    docker volume rm -f %PARENT_FOLDER%_acs-volume
    docker volume rm -f %PARENT_FOLDER%_db-volume
    docker volume rm -f %PARENT_FOLDER%_ass-volume
EXIT /B 0

:purgeAll
   docker volume prune -f
EXIT /B 0