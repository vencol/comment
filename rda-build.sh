#!/bin/sh
time_start=$(date +%s)
if [[ $1 = "" ]]; then
	echo "need target, A6orA6CorA7orA5orA20, eg: ./build.sh A6"
	exit
elif [[ $1 = "distclean" ]]; then
	echo "remove build and hex folder"
	rm -rf build hex
	echo "remove complete"
elif [[ $1 = "clean" ]]; then
	echo "remove build folder"
	rm -rf build
	echo "remove complete"
fi
export CT_TARGET=8851ml_rdamodem
export CT_PRODUCT=AtCommandSet

if [[ $2 != "r" ]]; then
	export CT_RELEASE=debug
#elif [[ $2 != "c" ]]; then
#	export CT_RELEASE=debug
#elif [[ $2 != "C" ]]; then
#	export CT_RELEASE=release
else
	export CT_RELEASE=release
fi

if [[ $3 == "" ]]; then
	export CT_PATH=
else
	export CT_PATH=$3
fi

echo CT_PATH: ${CT_PATH}
######## CPU number########
CPU_NUMBER=`cat /proc/cpuinfo | grep vendor_id | wc -l`

if [[ $2 != "c" &&  $2 != "C" ]]; then
	if [ $1 == A9 ]; then
		CT_TARGET=8955_modem_u02
		ctmake -j${CPU_NUMBER} CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=${CT_PRODUCT} ${CT_PATH}
	elif [ $1 == A99 ]; then
		CT_TARGET=8955_modem_no_at
		ctmake -j${CPU_NUMBER} CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=0 CT_PRODUCT=${CT_PRODUCT} ${CT_PATH}
	fi
else
	if [ $1 == A6 ]; then
		CT_TARGET=8851ml_rdamodem
		ctmake -j4 CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=${CT_PRODUCT} CT_RESGEN=yes clean lod
	elif [ $1 == A6C ]; then
		CT_TARGET=8851bl_rdamodem
		ctmake -j4 CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=${CT_PRODUCT} CT_RESGEN=yes clean lod
	elif [ $1 == A7 ]; then
		CT_TARGET=8951gl_rdamodem
		ctmake -j4 CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=${CT_PRODUCT} CT_RESGEN=yes clean lod
	elif [ $1 == A5 ]; then
		CT_TARGET=A5
		ctmake -j4 CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=${CT_PRODUCT} CT_RESGEN=yes clean lod
	elif [ $1 == A20 ]; then
		CT_TARGET=A20
		ctmake -j4 CT_TARGET=${CT_TARGET}  CT_USER=FAE CT_RELEASE=${CT_RELEASE} WITH_SVN=0 CT_MODEM=1 CT_PRODUCT=${CT_PRODUCT} CT_RESGEN=yes clean lod
	fi
fi

HEX_PATH=${CT_TARGET}_${CT_PRODUCT}_${CT_RELEASE}
if [ $HOSTNAME == WIN10-706010604 ]; then
	HOST_DIR_PATH=/cygdrive/e/rdaprojects/airm2m/csdk/platform/csdk
	cp -f hex/${HEX_PATH}/${HEX_PATH}.elf ${HOST_DIR_PATH}/SW_V1000_csdk.elf
	cp -f hex/${HEX_PATH}/${HEX_PATH}_flash.lod ${HOST_DIR_PATH}/SW_V1000_csdk.lod
fi
time_end=$(date +%s)
time_cost=$(($time_end - $time_start))
date_time_now=$(date +%F\ \ %H:%M:%S)
echo "Build time: $date_time_now"
echo "Build Cost time: $time_cost s"

