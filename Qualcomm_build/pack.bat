
@cd ..
@set Star_PATH= %cd%

@set PYPATH=C:\python27
@set path=%PYPATH%;%path%
@SET MODEM_PATH=%Star_PATH%\modem_proc
@SET MODEM_BIN=%MODEM_PATH%\build\ms\bin\8998.gen.prod
@SET MBNpack=%Star_PATH%\common\build\ufs\bin\asic\pil_split_bins

@RMDIR /S /Q %Star_PATH%\Qualcomm_BIN\Signed
@REM RMDIR /S /Q %Star_PATH%\Qualcomm_BIN_SDM630
@REM @IF NOT EXIST %Star_PATH%\mbn\Titan\Factory\SDM660\oem_hw.txt GOTO buildfail
@REM @IF NOT EXIST %Star_PATH%\mbn\Titan\WW\Shipping\SDM660\oem_hw.txt GOTO buildfail

@REM @XCOPY %Star_PATH%\mbn\Titan\Certificaiton\configs_SDM660 %Star_PATH%\modem_proc\mcfg\configs /E /Y /I 
@REM @XCOPY %Star_PATH%\mbn\Titan\mbn %Star_PATH%\modem_proc /E /Y /I 

@cd %MODEM_BIN%
@IF EXIST signed_mba.mbn COPY signed_mba.mbn mba.mbn
@IF EXIST signed_qdsp6sw.mbn COPY signed_qdsp6sw.mbn qdsp6sw.mbn
@IF NOT EXIST qdsp6sw.mbn GOTO buildfail

@REM pack image
echo start to pack image

cd %Star_PATH%\common\build
rmdir /S /Q ufs

@REM pack
@MD %Star_PATH%\Qualcomm_BIN\Signed
@REM @MD %Star_PATH%\Qualcomm_BIN\WW\Shipping
@REM @MD %Star_PATH%\Qualcomm_BIN\WW\Test
@REM @MD %Star_PATH%\Qualcomm_BIN\Factory

@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_hw\oem_hw.txt
@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt
@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_sw\mbn_sw.dig

@REM CD\
@REM CD %Star_PATH%\common\build

@REM pack facroty modem
@REM @RMDIR /S /Q ufs
@REM @COPY /Y %Star_PATH%\mbn\Titan\Factory\SDM660\oem_hw.txt %MODEM_PATH%\mcfg\configs\mcfg_hw\oem_hw.txt
@REM @COPY /Y %Star_PATH%\mbn\Titan\Factory\SDM660\oem_sw.txt %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt
@REM @IF NOT EXIST %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt GOTO buildfail
@Python build.py --nonhlos
@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_hw\oem_hw.txt
@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt

@COPY /Y ufs\bin\asic\NON-HLOS.bin %Star_PATH%\Qualcomm_BIN\Signed\NON-HLOS.bin
@IF NOT EXIST %Star_PATH%\Qualcomm_BIN\Signed\NON-HLOS.bin GOTO buildfail


@REM pack WW shipping modem
@REM @RMDIR /S /Q ufs
@REM @MD ufs\bin\asic\pil_split_bins
@REM @COPY /Y %Star_PATH%\mbn\Titan\WW\Shipping\ims_cfg.xml %MBNpack%\
@REM @COPY /Y %Star_PATH%\mbn\Titan\WW\Shipping\Data.msc %MBNpack%\
@REM COPY /Y %Star_PATH%\mbn\Titan\WW\Shipping\SDM660\oem_hw.txt %MODEM_PATH%\mcfg\configs\mcfg_hw\oem_hw.txt
@REM COPY /Y %Star_PATH%\mbn\Titan\WW\Shipping\SDM660\oem_sw.txt %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt
@REM COPY /Y %Star_PATH%\mbn\Titan\WW\Shipping\SDM660\mbn_sw.dig %MODEM_PATH%\mcfg\configs\mcfg_sw\mbn_sw.dig

@REM @IF NOT EXIST %MBNpack%\ims_cfg.xml GOTO buildfail
@REM @IF NOT EXIST %MBNpack%\Data.msc GOTO buildfail
@REM @IF NOT EXIST %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt GOTO buildfail
@REM @IF NOT EXIST %MODEM_PATH%\mcfg\configs\mcfg_sw\mbn_sw.dig GOTO buildfail
@REM @Python build.py --nonhlos
@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_hw\oem_hw.txt
@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt

@REM @COPY /Y ufs\bin\asic\NON-HLOS.bin %Star_PATH%\Qualcomm_BIN\WW\Shipping\NON-HLOS_660.bin
@REM @IF NOT EXIST %Star_PATH%\Qualcomm_BIN\WW\Shipping\NON-HLOS_660.bin GOTO buildfail


@REM pack WW test modem
@REM @RMDIR /S /Q ufs
@REM @MD ufs\bin\asic\pil_split_bins
@REM @COPY /Y %Star_PATH%\mbn\Titan\WW\Test\ims_cfg.xml %MBNpack%\
@REM @COPY /Y %Star_PATH%\mbn\Titan\WW\Test\Data.msc %MBNpack%\
@REM @COPY /Y %Star_PATH%\mbn\Titan\WW\Test\SDM660\oem_hw.txt %MODEM_PATH%\mcfg\configs\mcfg_hw\oem_hw.txt
@REM @COPY /Y %Star_PATH%\mbn\Titan\WW\Test\SDM660\oem_sw.txt %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt
@REM @COPY /Y %Star_PATH%\mbn\Titan\WW\Test\SDM660\mbn_sw.dig %MODEM_PATH%\mcfg\configs\mcfg_sw\mbn_sw.dig

@REM @IF NOT EXIST %MBNpack%\ims_cfg.xml GOTO buildfail
@REM @IF NOT EXIST %MBNpack%\Data.msc GOTO buildfail
@REM @IF NOT EXIST %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt GOTO buildfail
@REM @IF NOT EXIST %MODEM_PATH%\mcfg\configs\mcfg_sw\mbn_sw.dig GOTO buildfail
@REM @Python build.py --nonhlos
@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_hw\oem_hw.txt
@REM @DEL /Q %MODEM_PATH%\mcfg\configs\mcfg_sw\oem_sw.txt

@REM @COPY /Y ufs\bin\asic\NON-HLOS.bin %Star_PATH%\Qualcomm_BIN\WW\Test\NON-HLOS_660.bin
@REM @IF NOT EXIST %Star_PATH%\Qualcomm_BIN\WW\Test\NON-HLOS_660.bin GOTO buildfail



@ECHO 
@ECHO 
@ECHO 
@ECHO  ************************************
@ECHO          %MCHIP% BUILD PASS
@ECHO  ************************************
@ECHO 
@ECHO 
@ECHO 
@REM MOVE %Star_PATH%\Qualcomm_BIN %Star_PATH%\Qualcomm_BIN_SDM660
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