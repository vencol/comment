#!/bin/sh
time_start=$(date +%s)

if [[ $1 == "d" ]]; then
	export CT_RELEASE=debug
elif [[ $1 == "r" ]]; then
	export CT_RELEASE=release
else
	if [[ $1 == "menu" ]]; then
    	env/win32/mconf.exe kconfig
	elif [[ $1 == "newc" ]]; then
        env/win32/conf.exe  --oldaskconfig kconfig
	elif [[ $1 == "defc" ]]; then
        env/win32/conf.exe  --alldefconfig kconfig
	else
		echo "pls use the option,d:debug r:release menu/newc/defc for config"
	fi
	exit
fi

if [[ $2 == "" ]]; then
	export CT_PATH=
else
	export CT_PATH=$2
fi

export CT_TARGET=8955_modem_v1
export CT_PRODUCT=AT


HEX_PATH=${CT_TARGET}_${CT_PRODUCT}_${CT_RELEASE}
BLFOTA_NAME=hex/${HEX_PATH}/blfota_${HEX_PATH}_flash.lod
if [[ ! -e $BLFOTA_NAME ]];then
	echo $BLFOTA_NAME
	cd toolpool/blfota
	ctmake -r -j16 CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=${CT_PRODUCT}
	cd ../../
fi

ctmake -r -j16 CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=${CT_PRODUCT} ${CT_PATH}
env/utils/dual_boot_merge.py  --bl hex/${HEX_PATH}/blfota_${HEX_PATH}_flash.lod  --lod hex/${HEX_PATH}/${HEX_PATH}_flash.lod --output hex/${HEX_PATH}/${HEX_PATH}_merge.lod



if [ $HOSTNAME == xp-rd ]; then
	HOST_DIR_PATH=/cygdrive/c/Share/wyk
	cp hex/${HEX_PATH}/${HEX_PATH}_flash.lod ${HOST_DIR_PATH}/${1}-${PROJ}_${HEX_PATH}.lod
	chmod 777 ${HOST_DIR_PATH} -R
elif [ $HOSTNAME == Neucrack-win10 ]; then
	echo "Neucrack-win10, hex file in hex folder"
else
	HOST_DIR_PATH=$PROJ_ROOT/flashfile
	cp hex/${HEX_PATH}/${HEX_PATH}_flash.lod ${HOST_DIR_PATH}/${1}-${PROJ}_${HEX_PATH}.lod
	chmod 777 ${HOST_DIR_PATH} -R
fi
time_end=$(date +%s)
time_cost=$(($time_end - $time_start))
date_time_now=$(date +%F\ \ %H:%M:%S)
echo "Build time: $date_time_now"
echo "Build Cost time: $time_cost s"

