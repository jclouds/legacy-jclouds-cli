@echo off
rem
rem
rem    Licensed to the Apache Software Foundation (ASF) under one or more
rem    contributor license agreements.  See the NOTICE file distributed with
rem    this work for additional information regarding copyright ownership.
rem    The ASF licenses this file to You under the Apache License, Version 2.0
rem    (the "License"); you may not use this file except in compliance with
rem    the License.  You may obtain a copy of the License at
rem
rem       http://www.apache.org/licenses/LICENSE-2.0
rem
rem    Unless required by applicable law or agreed to in writing, software
rem    distributed under the License is distributed on an "AS IS" BASIS,
rem    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem    See the License for the specific language governing permissions and
rem    limitations under the License.
rem

if not "%ECHO%" == "" echo %ECHO%

setlocal
set DIRNAME=%~dp0%
set PROGNAME=%~nx0%
set ARGS=%*

rem Sourcing environment settings for karaf similar to tomcats setenv
SET KARAF_SCRIPT="shell.bat"
if exist "%DIRNAME%setenv.bat" (
  call "%DIRNAME%setenv.bat"
)

rem Check console window title. Set to Karaf by default
if not "%KARAF_TITLE%" == "" (
    title %KARAF_TITLE%
) else (
    title Karaf
)

rem Check/Set up some easily accessible MIN/MAX params for JVM mem usage
if "%JAVA_MIN_MEM%" == "" (
    set JAVA_MIN_MEM=128M
)
if "%JAVA_MAX_MEM%" == "" (
    set JAVA_MAX_MEM=512M
)

goto BEGIN

:warn
    echo %PROGNAME%: %*
goto :EOF

:BEGIN

rem # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if not "%KARAF_HOME%" == "" (
    call :warn Ignoring predefined value for KARAF_HOME
)
set KARAF_HOME=%DIRNAME%..
if not exist "%KARAF_HOME%" (
    call :warn KARAF_HOME is not valid: "%KARAF_HOME%"
    goto END
)

if not "%KARAF_BASE%" == "" (
    if not exist "%KARAF_BASE%" (
       call :warn KARAF_BASE is not valid: "%KARAF_BASE%"
       goto END
    )
)
if "%KARAF_BASE%" == "" (
  set "KARAF_BASE=%KARAF_HOME%"
)

if not "%KARAF_DATA%" == "" (
    if not exist "%KARAF_DATA%" (
        call :warn KARAF_DATA is not valid: "%KARAF_DATA%"
        goto END
    )
)
if "%KARAF_DATA%" == "" (
    set "KARAF_DATA=%KARAF_BASE%\data"
)

if [%1]==[] (
        echo "Usage:jclouds {category} {action} {options/arguments}."
        echo ""
        echo "Categories: node, group, image, location hardware"
        echo "Actions: list, create, destroy, runscript"
        echo ""
        echo "Options:"
        echo "--proivder:       The id of the provider."
        echo "--api:            The id of the api."
        echo "--endpoint:       The endpoint."
        echo "--identity:       The identity."
        echo "--credential:     The credential."
        goto END
)

if [%2]==[] (
        echo "Usage:jclouds {category} {action} {options/arguments}."
        echo ""
        echo "Categories: node, group, image, location hardware"
        echo "Actions: list, create, destroy, runscript"
        echo ""
        echo "Options:"
        echo "--proivder:       The id of the provider."
        echo "--api:            The id of the api."
        echo "--endpoint:       The endpoint."
        echo "--identity:       The identity."
        echo "--credential:     The credential."
        goto END
)

set CATEGORY=%1
set ACTION=%2

:EXECUTE
﻿SHIFT
SHIFT
    if "%SHIFT%" == "true" SET ARGS=%2 %3 %4 %5 %6 %7 %8
    if not "%SHIFT%" == "true" SET ARGS=%1 %2 %3 %4 %5 %6 %7 %8
    %KARAF_HOME%\bin\%KARAF_SCRIPT% jclouds:%CATEGORY%-%ACTION% %ARGS%

rem # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:END

endlocal

