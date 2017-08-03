
@CD ..
@SET Star_PATH=%CD%

@SET ARMROOT=C:\apps\RVDS221
@SET ARMINC=C:\apps\RVDS221\RVCT\Data\2.2\349\include\windows
@SET ARMLIB=C:\apps\RVDS221\RVCT\Data\2.2\349\lib
@SET ARMBIN=%ARMROOT%\RVCT\Programs\2.2\349\win_32-pentium
@SET ARMHOME=%ARMROOT%
@SET ARMTOOLS=RVCT221
@SET PYPATH=C:\python27
@SET GNUPATH=C:\utils\cygwin\bin
@SET LC_ALL=C
@SET path=%ARMBIN%;%PYPATH%;%GNUPATH%;%path%

@SET MODEM_PATH=%Star_PATH%\modem_proc
@SET BIN=%MODEM_PATH%\build\ms\bin
@SET TASK= %MODEM_PATH%\core\debugtools\task\src
@SET BUILD_PATH=%MODEM_PATH%\build\ms 
@SET AUTOGEN= %MODEM_PATH%\core\debugtools\rcinit_playbook\build
@SET MODEM_BIN=%MODEM_PATH%\build\ms\bin\8998.gen.prod
@REM Fit 7F build process -Eric7_Chen-20170706 +
@set PROJECT_NAME=ZS551KL
@REM Fit 7F build process -Eric7_Chen-20170706 -
@SET MCHIP=8998
@CALL :modemBuild
@EXIT /b

:modemBuild
@CALL %Star_PATH%\Qualcomm_build\SetID.bat
@REM Build
@IF "%MCHIP%" == "8998" SET MBUILD_ID=8998.gen.prod

@CD %BUILD_PATH%
@DEL /S /Q %BIN%\%MBUILD_ID%\non_signed_qdsp6sw.mbn
@DEL /S /Q %BIN%\%MBUILD_ID%\non_signed_mba.mbn
@DEL /S /Q %BIN%\%MBUILD_ID%\qdsp6sw.mbn
@DEL /S /Q %BIN%\%MBUILD_ID%\mba.mbn
@DEL /S /Q %BIN%\%MBUILD_ID%\signed_mba.mbn
@DEL /S /Q %BIN%\%MBUILD_ID%\signed_qdsp6sw.mbn
@DEL /S /Q %AUTOGEN%\modem_proc\qdsp6\%MBUILD_ID%\rcinit_autogen.o

@IF "%MCHIP%" == "8998" CALL build.cmd 8998.gen.prod -k

@IF NOT EXIST %BIN%\%MBUILD_ID%\mba.mbn  GOTO buildfail
@IF NOT EXIST %BIN%\%MBUILD_ID%\qdsp6sw.mbn  GOTO buildfail

@CD bin\%MCHIP%.gen.prod
@COPY qdsp6sw.mbn non_signed_qdsp6sw.mbn
@COPY mba.mbn non_signed_mba.mbn

@REM pack 


@MD %Star_PATH%\Qualcomm_BIN\Non_signed


@CD\
@CD %Star_PATH%\common\build
@REM pack non-signed modem
@RMDIR /S /Q ufs
@Python build.py --nonhlos

@COPY /Y ufs\bin\asic\NON-HLOS.bin %Star_PATH%\Qualcomm_BIN\Non_signed\NON-HLOS.bin
@IF NOT EXIST %Star_PATH%\Qualcomm_BIN\Non_signed\NON-HLOS.bin  GOTO buildfail

@ECHO 
@ECHO 
@ECHO 
@ECHO  ************************************
@ECHO          %MCHIP% BUILD PASS
@ECHO  ************************************
@CD  %Star_PATH%\Qualcomm_build
@IF EXIST D:\Zeus_sign\sectools.py Call sign.bat
@ECHO 
@ECHO 
@ECHO 
@GOTO :eof

:buildfail
@ECHO 
@ECHO 
@ECHO 
@ECHO  ************************************
@ECHO          %MCHIP% BUILD FAIL
@ECHO  ************************************
@ECHO 
@ECHO 
@ECHO 
@EXIT /b 1
