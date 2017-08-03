#!/bin/bash

export root_path=${PWD}
export MODEM_PATH=${root_path}/../../modem_proc
export MODEM_BIN=${root_path}/bin/8998.gen.prod
export SIGN_PATH=${HOME}/PS_data/ZS551KL_Zeus/sign_FW
export MCHIP=8998

#Declare the sign_Chenk function
function sign_check

  if [ "$1" == "0" ]; then
    echo  "************************************"
    echo  "        ${MCHIP} SIGN PASS"
    echo  "************************************"
    echo 
    echo 
    echo 
  fi

  if [ "$1" == "1" ]; then
    echo 
    echo 
    echo 
    echo  "************************************"
    echo  "        ${MCHIP} SIGN FAIL"    echo  "************************************"
    
    echo 
    echo 
  fi

}


rm -rf  ${SIGN_PATH}/mba.mbn
rm -rf  ${SIGN_PATH}/qdsp6sw.mbn
rm -rf  ${MODEM_BIN}/signed_mba_8998.mbn
rm -rf  ${MODEM_BIN}/signed_qdsp6sw_8998.mbn
rm -rf  ${SIGN_PATH}/secimage_output/

cp  ${MODEM_BIN}/mba.mbn ${MODEM_BIN}/non_signed_mba.mbn
cp  ${MODEM_BIN}/qdsp6sw.mbn ${MODEM_BIN}/non_signed_qdsp6sw.mbn

cp  ${MODEM_BIN}/non_signed_mba.mbn ${SIGN_PATH}/mba.mbn
cp  ${MODEM_BIN}/non_signed_qdsp6sw.mbn ${SIGN_PATH}/qdsp6sw.mbn

if [[ ! -f ${SIGN_PATH}/qdsp6sw.mbn ]];then
echo "Rename non_signed_mba.mbn & non_signed_qdsp6sw.mbn fail"
sign_check 1
fi 


cd ${SIGN_PATH}

python sectools.py secimage -c config/${MCHIP}/secimagev2_${MCHIP}.xml -i qdsp6sw.mbn -sa
python sectools.py secimage -c config/${MCHIP}/secimagev2_${MCHIP}.xml -i mba.mbn -sa

cd ${SIGN_PATH}/secimage_output

if [[ ! -f ${SIGN_PATH}/secimage_output/ZS551KL/modem/modem.mbn ]];then
echo "Signed_qdsp6sw.mbn sign fail"
sign_check 1
fi

if [[ ! -f ${SIGN_PATH}/secimage_output/ZS551KL/mba/mba.mbn ]];then
echo "Signed_mba.mbn sign fail"
sign_check 1
else
fi

echo 
echo 
echo "Copy Siged qdsp6sw & mba to Bin path"
cp  ${SIGN_PATH}/secimage_output/ZS551KL/mba/mba.mbn ${MODEM_BIN}/signed_mba_${MCHIP}.mbn
cp  ${SIGN_PATH}/secimage_output/ZS551KL/modem/modem.mbn ${MODEM_BIN}/signed_qdsp6sw_${MCHIP}.mbn

if [[ ! -f ${MODEM_BIN}/signed_qdsp6sw_${MCHIP}.mbn ]];then 
echo "Rename signed_mba.mbn & signed_qdsp6sw.mbn fail"
sign_check 1
else
sign_check 0
fi

cp ${MODEM_BIN}/signed_mba_${MCHIP}.mbn ${MODEM_BIN}/mba.mbn
cp ${MODEM_BIN}/signed_qdsp6sw_${MCHIP}.mbn ${MODEM_BIN}/qdsp6sw.mbn

# cd ${root_path}
# ./pack.sh



