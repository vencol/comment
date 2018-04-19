@echo off

REM set STIME=%time%
REM set /a MM=%STIME:~3,2%
REM set /a SS=%STIME:~6,2%
if "%userdomain%" == "WIN10-706010604" (
    set CSDTK4_PATH=G:\CSDTK41
)else (
    if "%userdomain%" == "HUANG" (
        set CSDTK4_PATH=D:\CSDTK41
    )else (
        echo pls set you CSDTK4_PATH in build.bat
        goto end
    )
)

set BUILD_PATH=%cd%
set SOFT_WORKDIR=%BUILD_PATH:\=/%
if not defined CSDTK4INSTALLDIR (
    echo no CSDTK4 path creating
    call %CSDTK4_PATH%\CSDTKvars.bat
    set ptemp=%BUILD_PATH%\env\utils;%BUILD_PATH%\env\win32;
    echo first time set csdtk auto
)else (
    if "%CSDTKVER%" =="4" (
        echo CSDTK4 path exit
        set ptemp=
    )else (
        echo CSDTK4 path creating
        call %CSDTK4_PATH%\CSDTKvars.bat
        set ptemp=%BUILD_PATH%\env\utils;%BUILD_PATH%\env\win32;
    )
)
set PATH=%ptemp%%PATH%

set CT_TARGET=8955_modem_v1
set CT_PRODUCT=AT
if "%1%" == "release" (
    echo release
    set CT_RELEASE=release
)else (
    echo debug
    set CT_RELEASE=debug
)

set FUN=
set /p FUN=enter the CT_PATH or config( menuc\defc\menu ):

if "%FUN%a" == "a" (
    ::set CT_PATH=at/atk/time
    ::goto compile
    echo compile path %FUN%
    set CT_PATH=
    goto compile
)
if "%FUN%" == "menu" (
    env\win32\mconf.exe kconfig
    copy .config target\%CT_TARGET%\target.config
    copy fpconfig.h target\%CT_TARGET%\include\fpconfig.h
    goto end
)else (
    if  "%FUN%" == "menuc" (
        env\win32\mconf.exe kconfig
        copy .config target\%CT_TARGET%\target.config
        copy fpconfig.h target\%CT_TARGET%\include\fpconfig.h
        del build\%CT_TARGET%\_default_\at\ate\obj\debug\at_command_table.gperf.h
        goto end
    )else (
        if  "%FUN%" == "newc" (
            env\win32\conf.exe  --oldaskconfig kconfig
            copy .config target\%CT_TARGET%\target.config
            copy fpconfig.h target\%CT_TARGET%\include\fpconfig.h
            del build\%CT_TARGET%\_default_\at\ate\obj\debug\at_command_table.gperf.h
            goto end
        )else (
            if not defined FUN (
            REM if "%FUN%" == "" (
                set CT_PATH= 
                echo compile path %CT_PATH% 
                goto compile
            ) else (
                if exist "%FUN%" (
                    set CT_PATH=%FUN:\=/%
                    echo compile path %FUN%
                    goto compile
                ) else (
                    echo compile path %FUN% not exist
                    goto end
                )
            )
        )
    )
)

REM set MAKEDIR=%CSDTK4INSTALLDIR%%CSDTKMAKEDIR%\

:compile
    set HEX_NAME=%CT_TARGET%_%CT_PRODUCT%_%CT_RELEASE%
    set BLFOTA_HEX_PATH=%BUILD_PATH%\hex\%HEX_NAME%\blfota_%HEX_NAME%_flash.lod
    if exist %BLFOTA_HEX_PATH% (
        echo blfota had built %number_of_processors%
    )else ( 
        echo building blfota
        cd toolpool\blfota
        %MAKEDIR%make -r -j%number_of_processors% CT_TARGET=%CT_TARGET% CT_USER=FAE CT_RELEASE=%CT_RELEASE% WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=%CT_PRODUCT%
        cd ..\..\
    )
    %MAKEDIR%make -r -j%number_of_processors% CT_TARGET=%CT_TARGET% CT_USER=FAE CT_RELEASE=%CT_RELEASE% WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=%CT_PRODUCT% CT_MODULES=%CT_PATH%
    python env\utils\dual_boot_merge.py  --bl %BLFOTA_HEX_PATH%  --lod hex\%HEX_NAME%\%HEX_NAME%_flash.lod --output hex\%HEX_NAME%\%HEX_NAME%_merge.lod
    goto end

:end
    REM set ETIME=%time%
    REM set /a EMM=%ETIME:~3,2%
    REM set /a ESS=%ETIME:~6,2%
    REM set /a EM=%EMM%-%MM%
    REM set /a ES=%ESS%-%SS%
    REM echo "time:%date% total:%ES%min %ES%s"
    echo time:%date% %time%
    pause