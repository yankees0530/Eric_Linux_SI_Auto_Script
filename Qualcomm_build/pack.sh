#!/bin/bash

export Pack_PATH=${PWD}

export MODEM_PATH=${Pack_PATH}/modem_proc
export MODEM_BIN=${MODEM_PATH}/build/ms/bin/8998.gen.prod
export MBNpack=${Pack_PATH}/../common/build/ufs/bin/asic/pil_split_bins

function pack_check()
{

  if [ "$1" == "0" ];then
    echo 
    echo
    echo
    echo  "************************************"
    echo  "        ${MCHIP} BUILD PASS          "
    echo  "************************************"
    echo
    echo
    echo

  fi

  if [ "$1" == "1" ];then
   echo
   echo
   echo
   echo  "************************************"
   echo  "        ${MCHIP} BUILD FAIL          "
   echo  "************************************"
   echo
   echo
   echo

 fi
}


# @RMDIR /S /Q ${Pack_PATH}/Qualcomm_BIN/Signed
# @REM RMDIR /S /Q ${Pack_PATH}/Qualcomm_BIN_SDM630
# @REM @IF NOT EXIST ${Pack_PATH}/mbn/Titan/Factory/SDM660/oem_hw.txt GOTO buildfail
# @REM @IF NOT EXIST ${Pack_PATH}/mbn/Titan/WW/Shipping/SDM660/oem_hw.txt GOTO buildfail

# @REM @XCOPY ${Pack_PATH}/mbn/Titan/Certificaiton/configs_SDM660 ${Pack_PATH}/modem_proc/mcfg/configs /E /Y /I 
# @REM @XCOPY ${Pack_PATH}/mbn/Titan/mbn ${Pack_PATH}/modem_proc /E /Y /I 

#@cd %MODEM_BIN%
#@IF EXIST signed_mba_8998.mbn COPY signed_mba_8998.mbn mba.mbn
#@IF EXIST signed_qdsp6sw_8998.mbn COPY signed_qdsp6sw_8998.mbn qdsp6sw.mbn
#@IF NOT EXIST qdsp6sw.mbn GOTO buildfail

# @REM pack image
echo start to pack image

cd ${Pack_PATH}/../common/build
rm -fr ./ufs

mkdir -p ${Pack_PATH}/../Qualcomm_BIN/Signed

python build.py --nonhlos

cp -fr ./ufs/bin/asic/NON-HLOS.bin ${Pack_PATH}/../Qualcomm_BIN/Signed/NON-HLOS.bin

if [[ ! -f ${Pack_PATH}/../Qualcomm_BIN/Signed/NON-HLOS.bin ]];then
pack_check 1
else
pack_check 0
fi



