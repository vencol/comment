
FILE_PATH=./env/compilation/compilerules.mk
# FILE_PATH=./test.txt

if [[ "$1x" == "addx" ]]; then
    sed -i '/##### merge_lod_here #####/,/##### merge_lod_here #####/d' ${FILE_PATH}
    sed -i '/##### merge_lod_output_here #####/,/##### merge_lod_output_here #####/d' ${FILE_PATH}
    sed  -i '/LDPPFLAGS := ${LDPPFLAGS} ${foreach tmpFlag, ${CHIP_EXPORT_FLAG}, -D${tmpFlag}}/a\##### merge_lod_here #####\nRAM_SIZE		=	0x00265000 \nUSER_BASE		=	0x00240000 \nUSER_SIZE		=	0x00100000 \nUSER_DATA_BASE	=	0x00361000\nUSER_DATA_SIZE	=	0x00099000\nLDPPFLAGS += -DUSER_BASE=${FLASH_BASE}+${USER_BASE} -DUSER_SIZE=${USER_SIZE}\n##### merge_lod_here #####' ${FILE_PATH}
    sed  -i '/@${ECHO} "USER_DATA_SIZE:=       $(USER_DATA_SIZE)"         >> $(TARGET_FILE)/a\##### merge_lod_output_here #####\n	@${ECHO} "USER_BASE:=       	 $(USER_BASE)"         		>> $(TARGET_FILE)\n	@${ECHO} "USER_SIZE:=       	 $(USER_SIZE)"         		>> $(TARGET_FILE)\n##### merge_lod_output_here #####' ${FILE_PATH}
elif [[ "$1x" == "delx" ]]; then
    sed -i '/##### merge_lod_here #####/,/##### merge_lod_here #####/d' ${FILE_PATH}
    sed -i '/##### merge_lod_output_here #####/,/##### merge_lod_output_here #####/d' ${FILE_PATH}
    # rm 
else
    echo "pls use 'merge.sh add' to add"
    echo "pls use 'merge.sh del' to del"
fi
exit
