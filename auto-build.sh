#!/bin/bash

# Build Environment Parameter Setting 
export root_path=${HOME}
export build_path_7F=${HOME}/Zeus_Build/$1/Source/ASUS_8998_N_00159/modem_proc/build/ms
export build_path_3F=${HOME}/Zeus_Build/$1/Source/Qualcomm_build
export QCT_file_path_7F=${HOME}/Zeus_Build/$1/Source/ASUS_8998_N_00159/QCT_files
export QCT_file_path_3F=${HOME}/Zeus_Build/$1/Source/QCT_files
export QCT_BIN_7F=${HOME}/Zeus_Build/$1/Source/ASUS_8998_N_00159/Qualcomm_BIN/Signed
export QCT_BIN_3F=${HOME}/Zeus_Build/$1/Source/Qualcomm_BIN/Signed
export Signed_IMG_PATH_7F=${HOME}/Zeus_Build/$1/Source/ASUS_8998_N_00159/common/build
export Signed_IMG_PATH_3F=${HOME}/Zeus_Build/$1/Source/common/build

#Set Remote Disc path
export PS_data=${HOME}/PS_data
export modem_bin_remote=${HOME}/Modem_bin_notrelease/8998
export Temp_Space=${HOME}/DataExchange


function print()
{
 echo " ======================= welcome Zeus Auto Build ===============================================  "
 echo "                                                                             			 "
 echo " Please follow below format to trigger Zeus auto build                       			 "
 echo "                                                                             			 "
 echo "./auto-build.sh modem_version Branch_name build_type floor                   			 "
 echo "                                                                             			 "
 echo " modem_version : Please enter the naming rule of 3F PS                       			 "
 echo " Branch_name   : Open-Dev , Open-MR , OP-Dev , OP-MR , OP-Factory , 3F-PS    			 "
 echo " build_type    : rebuild, new, repack , new means new version build || repack not support now     "
 echo " floor         : 3F or 7F , in order to distiguish build structure           			 " 
 echo "                                                                             			 "
 echo " **************************** Branch Purpose ***************************************************  "
 echo " Branch purpose show as below :                                              			 "
 echo " Open-Dev   : Zeus Open Channel develop branch   (MSM8998 LA 1.1/AT2.0 )     			 "
 echo " Open-MR    : Zeus Open Channel MP/MR branch     (MSM8998 LA 1.1/AT2.0 )     			 "
 echo " OP-Dev     : Zeus Operator SKU develp branch    (MSM8998 LA 2.0/AT2.5 )     			 "
 echo " OP-MR      : Zeus IT-TIM Operator MP branch     (MSM8998 LA 2.0/AT2.5 )     			 "
 echo " OP-Factory : Zeus Operator SKU Factory branch (MSM8998 LA 2.0/AT2.5 )       			 "
 echo " 3F-PS      : Zeus 3F Operator SKU new porting branch (MSM8998 LA 2.0/AT2.5) 			 "
 echo "                                                                             			 "
 echo "                                                                             			 "
 echo " ================================================================================================ "
 echo " USER is "



}


# build_toogle() function used to build new version modem SW for 7F build Structure

function build_toggle()
{

mkdir -m 777 ${root_path}/Zeus_Build/$1 

	cd ${root_path}/Zeus_Build/$1

echo " ${PWD} "

	echo "Clone the remote reposity to build server"
		git clone ssh://10.72.70.239/PS_Team/8998_N/Source

	echo "Build verion is "$1" & Branch is "$2" "

	cd ${root_path}/Zeus_Build/$1/Source

echo " ${PWD} "

# If Git has new branch , th new branch should be added in the below case condition


		case "$2" in
   			"Open-Dev")
   				git checkout origin/QMC-8998_N_00159 -b Open-Dev
   			 ;;

  			"Open-MR")
   				git checkout origin/QMC-8998_N_00159-M0 -b Open-MR
   			 ;;
  
  			"OP-Dev")
   				git checkout origin/QMC-8998_N_20084 -b OP-Dev
 			 ;;

 			"OP-MR")
   				git checkout origin/QMC-8998_N_20084-M0 -b OP-MR
			 ;;

  			"OP-Factory")
   				git checkout origin/QMC-8998_N_20084-MP -b OP-Factory
			 ;;

 			"OP-NULL")
  				git checkout origin/QMC-8998_N-00195-OP -b test_branch
 			;;
                        *)
				echo " there is no Branch name defined in the shell , please creat it  "
			;;
		esac

	if [ "$2" != "OP-Factory" ]; then
		cd ${build_path_7F}
		./SetID.sh $1
		./Server_build_zs551kl-7F.sh 
	else 
		cd ${build_path_7F}
		./SetID.sh $1
		./Server_build_zs551kl_factory-7F.sh
	fi

		if [ "$?" == "0" ];then
  			mkdir -m 777 ${QCT_file_path_7F}
  			mkdir -m 777 -p ${QCT_BIN_7F} 
  			cd ../../
  			cp ./core/bsp/core_user_pic/build/8998.gen.prod/*.so ${QCT_file_path_7F}
  			cp ${build_path_7F}/M89988998.gen.prodQ*[0-9]*.elf ${QCT_file_path_7F}
  			cp ${build_path_7F}/orig_MODEM_PROC_IMG_8998.gen.prodQ.elf ${QCT_file_path_7F}
  			cp ${QCT_file_path_7F}/../wlan_proc/build/ms/WLAN_MERGED.elf ${QCT_file_path_7F}
  			cp ${build_path_7F}/../myps/qshrink/msg_hash_*.qsr4 ${QCT_file_path_7F}
  			cp ./core/bsp/elf_loader_wlan/build/8998.gen.prod/*.elf ${QCT_file_path_7F}
  			cp ${Signed_IMG_PATH_7F}/ufs/bin/asic/NON-HLOS.bin ${QCT_BIN_7F}/NON-HLOS.bin 

		fi
}


# build_toggle_rebuild() function  used to rebuild the existed modem SW for 7F build Structure

function build_toggle_rebuild()
{

echo "Build verion is "$1" & Branch is "$2" "

	cd ${root_path}/Zeus_Build/$1/Source

	if [ "$2" != "OP-Factory" ]; then
		cd ${build_path_7F}
		./SetID.sh $1
		./Server_build_zs551kl-7F.sh 
	else 
		cd ${build_path_7F}
		./SetID.sh $1
		./Server_build_zs551kl_factory-7F.sh
	fi

		if [ "$?" == "0" ];then
			mkdir -m 777 ${QCT_file_path_7F}
			mkdir -m 777 -p ${QCT_BIN_7F}
		        mkdir -m 777 ${modem_bin_remote}/$1
			cd ../../
			cp ./core/bsp/core_user_pic/build/8998.gen.prod/*.so ${QCT_file_path_7F}
			cp ${build_path_7F}/M89988998.gen.prodQ*[0-9]*.elf ${QCT_file_path_7F}
			cp ${build_path_7F}/orig_MODEM_PROC_IMG_8998.gen.prodQ.elf ${QCT_file_path_7F}
			cp ${QCT_file_path_7F}/../wlan_proc/build/ms/WLAN_MERGED.elf ${QCT_file_path_7F}
			cp ${build_path_7F}/../myps/qshrink/msg_hash_*.qsr4 ${QCT_file_path_7F}
			cp ./core/bsp/elf_loader_wlan/build/8998.gen.prod/*.elf ${QCT_file_path_7F}
			cp ${Signed_IMG_PATH_7F}/ufs/bin/asic/NON-HLOS.bin ${QCT_BIN_7F}/NON-HLOS.bi
			cp ${QCT_BIN_7F}/NON-HLOS.bin ${modem_bin_remote}/$1/NON-HLOS.bin
		fi
}

# build_toggle_3F
function build_toggle_3F()
{

mkdir -m 777 ${root_path}/Zeus_Build/$1 

echo " Call build_toggle_build_3F "

	sleep 3

	cd ${root_path}/Zeus_Build/$1

echo "Clone the remote reposity to build server"
	git clone ssh://10.72.70.239/PS_Team/8998_N/Source

echo "Build verion is "$1" & Branch is "$2" "

	cd ${root_path}/Zeus_Build/$1/Source

	git checkout origin/Zeus_201461_3F_PS -b 3F-PS

	cd ${build_path_3F}
	./build_zeus.sh $1


		if [ "$?" == "0" ];then
			mkdir -m 777 ${QCT_file_path_3F}
			mkdir -m 777 -p ${QCT_BIN_3F} 
			cd ../
			cp ./modem_proc/core/bsp/core_user_pic/build/8998.gen.prod/*.so ${QCT_file_path_3F}
			cp ${build_path_3F}/../modem_proc/build/ms/M89988998.gen.prodQ*[0-9]*.elf ${QCT_file_path_3F}
			cp ${build_path_3F}/../modem_proc/build/ms/orig_MODEM_PROC_IMG_8998.gen.prodQ.elf ${QCT_file_path_3F}
			cp ${QCT_file_path_3F}/../wlan_proc/build/ms/WLAN_MERGED.elf ${QCT_file_path_3F}
			cp ${build_path_3F}/../modem_proc/build/myps/qshrink/msg_hash_*.qsr4 ${QCT_file_path_3F}
			cp ./modem_proc/core/bsp/elf_loader_wlan/build/8998.gen.prod/*.elf ${QCT_file_path_3F}
			cp ${Signed_IMG_PATH_3F}/ufs/bin/asic/NON-HLOS.bin ${QCT_BIN_3F}/NON-HLOS.bin 

		fi

}

function build_toggle_rebuild_3F()
{

echo " Call build_toggle_rebuild_3F "
 
	sleep 3

	cd ${root_path}/Zeus_Build/$1

echo "Build verion is "$1" & Branch is "$2" "

	cd ${root_path}/Zeus_Build/$1/Source

	cd ${build_path_3F}
		./build_zeus.sh $1


	if [ "$?" == "0" ];then
		mkdir -m 777 ${QCT_file_path_3F}
		mkdir -m 777 -p ${QCT_BIN_3F} 
		cd ../
		cp ./modem_proc/core/bsp/core_user_pic/build/8998.gen.prod/*.so ${QCT_file_path_3F}
		cp ${build_path_3F}/../modem_proc/build/ms/M89988998.gen.prodQ*[0-9]*.elf ${QCT_file_path_3F}
		cp ${build_path_3F}/../modem_proc/build/ms/orig_MODEM_PROC_IMG_8998.gen.prodQ.elf ${QCT_file_path_3F}
		cp ${QCT_file_path_3F}/../wlan_proc/build/ms/WLAN_MERGED.elf ${QCT_file_path_3F}
		cp ${build_path_3F}/../modem_proc/build/myps/qshrink/msg_hash_*.qsr4 ${QCT_file_path_3F}
		cp ./modem_proc/core/bsp/elf_loader_wlan/build/8998.gen.prod/*.elf ${QCT_file_path_3F}
		cp ${Signed_IMG_PATH_3F}/ufs/bin/asic/NON-HLOS.bin ${QCT_BIN_3F}/NON-HLOS.bin 

	fi

}

function build_mbn_repack()
{

 echo " Call build_mbn_repack "


}


if [ "$1" == "help" ];then

	print

else

	if [ "$#" == 4 ];then

           if [ "$4" == "7F" ];then
		case "$3" in
                 "new")
		 build_toggle $1 $2 $3 $4
                     ;;
		 "rebuild") 
		 build_toggle_rebuild $1 $2 $3 $4
                     ;;
                 *)
                  echo " Please check with Eric"
                     ;;
	      esac
          fi
       	  
		if [ "$4" == "3F" ];then

			case "$3" in
	 		"rebuild")
     			build_toggle_rebuild_3F $1 $2 $3 $4
        			;;
			"repack")
			build_mbn_repack $1 $2 $3 $4
				;;
     
			*)

			build_toggle_3F $1 $2 $3 $4
				;;
			esac
		fi
        else 
         echo " Please enter four build parameter , refer to help , thanks !! "   

	fi

fi













