#!/bin/bash

#set Path variant and ChIP ID
export STAR_PATH=${PWD}
export Non_Sign_BIN=${STAR_PATH}/../Qualcomm_BIN/Non_signed
export MODEM_PATH=${STAR_PATH}/../modem_proc
export BIN=${MODEM_PATH}/build/ms/bin
export TASK=${MODEM_PATH}/core/debugtools/task/src
export BUILD_PATH=${MODEM_PATH}/build/ms 
export AUTOGEN=${MODEM_PATH}/core/debugtools/rcinit_playbook/build
# Fit 7F build process -Eric7_Chen-20170706 +
export PROJECT_NAME=ZS551KL
# Fit 7F build process -Eric7_Chen-20170706 -
export MCHIP=8998
export MBUILD_ID=8998.gen.prod

#Declare the Build_Chenk function 
function Build_Check()
{
  if [ "$1" == "0" ]; then
    echo
    echo
    echo
    echo  "************************************"
    echo  "        ${MCHIP} BUILD PASS"
    echo  "************************************"
    echo
    echo
    echo
    echo
  fi


  if [ "$1" == "1" ]; then
    echo
    echo
    echo
    echo  "************************************"
    echo  "        ${MCHIP} BUILD FAIL"
    echo  "************************************"
    echo
    echo
    echo
  fi

}


#Set the modem version in the version.h
./SetID.sh $1

echo "Erase Previous Binary files"
rm -rf ${BIN}/${MBUILD_ID}/non_signed_qdsp6sw.mbn
rm -rf ${BIN}/${MBUILD_ID}/non_signed_mba.mbn
rm -rf ${BIN}/${MBUILD_ID}/qdsp6sw.mbn
rm -rf ${BIN}/${MBUILD_ID}/mba.mbn
rm -rf ${AUTOGEN}/modem_proc/qdsp6/${MBUILD_ID}/rcinit_autogen.o

#Star modem build
cd ${BUILD_PATH}
echo "Start Modem build"
./build.sh 8998.gen.prod -k

#Check the qdsp6sw & mba build result
if [! -f ${BIN}/${MBUILD_ID}/mba.mbn ];then
echo "Check mba fail"
 Build_Check 1
fi

if [ ! -f ${BIN}/${MBUILD_ID}/qdsp6sw.mbn ];then
echo "Check qdsp6sw  fail"
 Build_Check 1
fi


cd ${BIN}/${MBUILD_ID}
cp ./qdsp6sw.mbn ./non_signed_qdsp6sw.mbn
cp ./mba.mbn ./non_signed_mba.mbn

rm -fr ${STAR_PATH}/../Qualcomm_BIN
mkdir -p -m 777 ${STAR_PATH}/../Qualcomm_BIN/Non_signed


#Pack NON-HLOS.bin form include qdsp6sw and mba 
cd ${STAR_PATH}/../common/build
rm -fr ./ufs
python build.py --nonhlos

# Copy NON-HLOS into Qualcomm_BIN folder and check the pack result
cp -fr ./ufs/bin/asic/NON-HLOS.bin ${STAR_PATH}/../Qualcomm_BIN/Non_signed/NON-HLOS.bin

if [[ ! -f ${Non_Sign_BIN}/NON-HLOS.bin ]];then
echo "NON-HLOS not in Non_signed folder"
 Build_Check 1
else
 Build_Check 0
 cd ${STAR_PATH}
 echo "Star to Sign qdsp6sw.mbn & mba.mbn"
./sign.sh
fi

