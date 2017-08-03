#!/bin/bash

# Setup necessary exportting for building image
export MBUILD_CHIP=8998
export MBUILD_PATH=${PWD}
export SIGN_PATH=${HOME}/Zeus_Sign
export PACK_PATH=${HOME}/Zeus_Build/$1/Source/ASUS_8998_N_00159/common/build
#Setup project specific features
export PROJECT_NAME=ZS551KL
export PROJECT_BUILD_VARIANT=
export PROJECT_BUILD_TARGET=gen
export USES_FACTORY_FEATURES=no
export EFS_ENABLE_FACTORY_IMAGE_SECURITY_HOLE=no

Print_help()
{
  echo "Usage: ./Server_build_project.sh target"
  echo "Target: help            (print help info)"
  echo "        clean           (clean build)"
  echo "        efs_tar         (build for generating EFS TAR file)"
  echo "        dis_slp         (build for disabling modem sleep)"  
  echo "        NULL(empty)     (normal build)"
  exit 0
}

# Check error function
Err_Check()
{
  if [ "$1" == "0" ]; then
    echo
    echo
    echo  "******************************************************************"
    echo  "                ${MBUILD_CHIP} AMSS ===== BUILD PASS"
    echo  "******************************************************************"
    cp  ./ufs/bin/asic/NON-HLOS.bin ${MBUILD_PATH}/bin/${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod/NON-HLOS.bin    
  fi

  if [ "$1" == "1" ]; then
    echo
    echo
    echo  "******************************************************************"
    echo  "                ${MBUILD_CHIP} AMSS ===== BUILD FAIL"
    echo  "******************************************************************"
  fi
  
  cd ${MBUILD_PATH}

  # Restore Zeus default MBNs to Default folder
  if [[ ( -d ../../mcfg/mcfg_gen/generic/common/Default_Zeus ) ]]; then
      cp ../../mcfg/mcfg_gen/generic/common/Default_Zeus/* ../../mcfg/mcfg_gen/generic/common/Default
      rm -rf ../../mcfg/mcfg_gen/generic/common/Default_Zeus
  fi
  
  # Restore oem_hw.txt and oem_sw.txt after factory build
  if [[ ( -f ../../mcfg/configs/mcfg_hw/oem_hw_official.txt ) ]]; then
      cp ../../mcfg/configs/mcfg_hw/oem_hw_official.txt ../../mcfg/configs/mcfg_hw/oem_hw.txt
      rm ../../mcfg/configs/mcfg_hw/oem_hw_official.txt
  fi

  if [[ ( -f ../../mcfg/configs/mcfg_sw/oem_sw_official.txt ) ]]; then
      cp ../../mcfg/configs/mcfg_sw/oem_sw_official.txt ../../mcfg/configs/mcfg_sw/oem_sw.txt
      rm ../../mcfg/configs/mcfg_sw/oem_sw_official.txt
  fi

  # echo "exit $1"  
  exit $1
}

# Setup build target
if   [ "$1"  ==  "help" ]; then
     echo "Target help"      
     Print_help
fi

if  [ "$1"  ==  "clean" ]; then
     echo "Target clean"
     rm -f ./.*${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod.dblite
     ./build.sh ${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod --clean
fi

if  [ "$1"  ==  "efs_tar" ]; then
     echo "Target efs_tar"
     rm -f ./.*${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod.dblite
     export EFS_ENABLE_FACTORY_IMAGE_SECURITY_HOLE=yes
     ./build.sh ${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod --clean
fi

if  [ "$1"  ==  "dis_slp" ]; then
     echo "Target dis_slp"
     rm -f ./.*${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod.dblite
     export DISABLE_SLEEP_MODES=yes
     ./build.sh ${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod --clean
fi

# Remove existed binary files and mobile.o
rm -rf ./bin/${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod/qdsp6sw.mbn 
rm -rf ./bin/${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod/mba.mbn
rm -f ./bin/${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod/NON-HLOS*.bin
rm -f ../../core/debugtools/task/build/core_root_libs/qdsp6/${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod/mobile.o

# Backup Zeus default MBNs to Default_Zeus folder
if [[ ( ! -d ../../mcfg/mcfg_gen/generic/common/Default_Zeus ) ]]; then
    mkdir ../../mcfg/mcfg_gen/generic/common/Default_Zeus
    cp ../../mcfg/mcfg_gen/generic/common/Default/* ../../mcfg/mcfg_gen/generic/common/Default_Zeus
fi

if [ "${USES_FACTORY_FEATURES}" == "yes" ]; then
# Copy Qualcomm default mcfg_hw files for factory build
    echo FACTORY BUILD! Copy Qualcomm default mcfg_hw
    rm ../../mcfg/mcfg_gen/generic/common/Default/*
    cp ../../mcfg/mcfg_gen/generic/common/Default_Qualcomm/*        ../../mcfg/mcfg_gen/generic/common/Default
else
# Copy ASUS default mcfg_hw files for official build
    echo OFFICIAL BUILD! Copy ASUS default mcfg_hw
    rm ../../mcfg/mcfg_gen/generic/common/Default/*
    cp ../../mcfg/mcfg_gen/generic/common/Default_Zeus/*        ../../mcfg/mcfg_gen/generic/common/Default
fi

if [ "${USES_FACTORY_FEATURES}" == "yes" ]; then
# Replace oem_hw.txt and oem_sw.txt files with oem_xx_factory.txt files for factory build
    echo FACTORY BUILD! Copy oem_hw_factory.txt
    cp ../../mcfg/configs/mcfg_hw/oem_hw.txt            ../../mcfg/configs/mcfg_hw/oem_hw_official.txt
    rm ../../mcfg/configs/mcfg_hw/oem_hw.txt
    cp ../../mcfg/configs/mcfg_hw/oem_hw_factory.txt    ../../mcfg/configs/mcfg_hw/oem_hw.txt

    cp ../../mcfg/configs/mcfg_sw/oem_sw.txt            ../../mcfg/configs/mcfg_sw/oem_sw_official.txt
    rm ../../mcfg/configs/mcfg_sw/oem_sw.txt
    cp ../../mcfg/configs/mcfg_sw/oem_sw_factory.txt    ../../mcfg/configs/mcfg_sw/oem_sw.txt
fi

# Build modem image
./build.sh ${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod bparams=-k

# Check build result
if [[ ( ! -f ./bin/${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod/mba.mbn ) || ( ! -f ./bin/${MBUILD_CHIP}.${PROJECT_BUILD_TARGET}.prod/qdsp6sw.mbn ) ]]; then
  echo "Can't find the qdsp6sw & mba file"
  Err_Check 1
fi    

#Star to qdsp6 & mba auto sign -Eric7_Chen
./sign-7F.sh


# Pack image (Meta build)
echo "start to pack image"

cd ../../../common/build
rm -f ../../contents.xml
rm -rf ./emmc/bin/asic/NON-HLOS.bin
rm -rf ./ufs/bin/asic/NON-HLOS.bin


# Copy operator MBN option XML files to pil_split_bins folder
mkdir -p ./ufs/bin/asic/pil_split_bins
cp ${MBN_OPTION_XML_PATH}/ims_cfg.xml ./ufs/bin/asic/pil_split_bins

cp contents_msm${MBUILD_CHIP}.xml ../../contents.xml
echo contents_msm${MBUILD_CHIP}.xml

cd ${PACK_PATH}

python build.py 
if [[(!  -f ./ufs/bin/asic/NON-HLOS.bin) ]]; then
  echo "Can't find the NON-HLOS file "
  echo " ${PACK_PATH} "
  Err_Check 1
else
  Err_Check 0
fi
