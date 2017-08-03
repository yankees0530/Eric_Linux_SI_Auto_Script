cd ..
set Star_PATH= %cd%

set PYPATH=C:\python27
set path=%PYPATH%;%path%
@SET MODEM_PATH=%Star_PATH%\modem_proc
@SET MODEM_BIN=%MODEM_PATH%\build\ms\bin\8998.gen.prod

@SET SIGN_PATH=D:\Zeus_sign

@DEL /Q %SIGN_PATH%\mba.mbn
@DEL /Q %SIGN_PATH%\qdsp6sw.mbn
@DEL /Q %MODEM_BIN%\signed_mba.mbn
@DEL /Q %MODEM_BIN%\signed_qdsp6sw.mbn
@RD /S /Q %SIGN_PATH%\secimage_output\



@COPY /Y %MODEM_BIN%\non_signed_mba.mbn %SIGN_PATH%\mba.mbn
@COPY /Y %MODEM_BIN%\non_signed_qdsp6sw.mbn %SIGN_PATH%\qdsp6sw.mbn
@IF NOT EXIST %SIGN_PATH%\qdsp6sw.mbn GOTO signfail



@cd %SIGN_PATH%
@SET MCHIP=8998
@CALL :sign


@cd %Star_PATH%\Qualcomm_build
@CALL pack.bat

@GOTO :eof

:sign
python sectools.py secimage -c config/%MCHIP%/secimagev2_%MCHIP%.xml -i qdsp6sw.mbn -sa
@IF NOT EXIST %SIGN_PATH%\secimage_output\ZS551KL\modem\modem.mbn GOTO signfail
python sectools.py secimage -c config/%MCHIP%/secimagev2_%MCHIP%.xml -i mba.mbn -sa
@IF NOT EXIST %SIGN_PATH%\secimage_output\ZS551KL\mba\mba.mbn GOTO signfail


@ECHO 
@ECHO 
@ECHO 
@COPY /Y %SIGN_PATH%\secimage_output\ZS551KL\mba\mba.mbn %MODEM_BIN%\signed_mba.mbn
@COPY /Y %SIGN_PATH%\secimage_output\ZS551KL\modem\modem.mbn %MODEM_BIN%\signed_qdsp6sw.mbn
@IF NOT EXIST %MODEM_BIN%\signed_qdsp6sw.mbn GOTO signfail


@ECHO  ************************************
@ECHO          %MCHIP% SIGN PASS
@ECHO  ************************************
@ECHO 
@ECHO 
@ECHO 
@GOTO :eof


:signfail
@ECHO 
@ECHO 
@ECHO 
@ECHO  ************************************
@ECHO          %MCHIP% SIGN FAIL
@ECHO  ************************************
@ECHO 
@ECHO 
@ECHO 
@EXIT /b 1