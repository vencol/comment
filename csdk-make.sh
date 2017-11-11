

start_time=`date +%s`
#where the cygwin install in unix path,example if windows path is G:\CSDTK\cygwin,cygwin path may be /cygdrive/g/CSDTK/cygwin
CYGWIN_HOME=/cygdrive/g/CSDTK/cygwin
if [[ ! -d $CYGWIN_HOME ]]; then
    echo  PATH $CYGWIN_HOME is not exist
    exit
fi

#set the path
export PATH=$CYGWIN_HOME/bin:$CYGWIN_HOME/crosscompiler/bin:$CYGWIN_HOME/cooltools:/bin:/usr/bin;
# echo path:$PATH

export SOFT_WORKDIR=`pwd`
if [[ $# -eq 1  ]]; then
    export IS_PROJECT_DIR=$SOFT_WORKDIR/$1
    if [[ ! -d $IS_PROJECT_DIR ]]; then
        echo "cust project $1 error path $IS_PROJECT_DIR";
        exit
    fi
    
    if [[ "$1x" == "initx" ]]; then
        sed -i '15d' Makefile
        sed -i "15i\#" Makefile
    else
        sed -i '15d' Makefile
        sed -i "15i\LOCAL_MODULE_DEPENDS += $1" Makefile
    fi


    export PROJ_NAME=$1
elif [[ $# -eq 2  ]]; then
    if [[ "$1x" == "cleanx" ]]; then
        if [[ "$2x" == "allx" ]]; then
            rm -rf $SOFT_WORKDIR/build
            rm -rf $SOFT_WORKDIR/hex
        else
            rm -rf $SOFT_WORKDIR/build/$2
            rm -rf $SOFT_WORKDIR/hex/$2
            rm -f $SOFT_WORKDIR/build/$2_build.log
        fi
        echo "clear project $2";
        exit
    elif [[ "$1x" == "demox" ]]; then
        export IS_PROJECT_DIR=$SOFT_WORKDIR/demo/$2
        if [[ ! -d $IS_PROJECT_DIR ]]; then
            echo "demo $2 error path $IS_PROJECT_DIR";
            exit
        fi
        export PROJ_NAME=$2

        # sed -i '5d' Makefile
        # sed -i "5i\LOCAL_LIBS += platform/lib/libinit.a" Makefile
        sed -i '15d' Makefile
        sed -i "15i\LOCAL_MODULE_DEPENDS += demo/$2" Makefile
    elif [[ "$1x" == "projectx" ]]; then
        export IS_PROJECT_DIR=$SOFT_WORKDIR/project/$2
        if [[ ! -d $IS_PROJECT_DIR ]]; then
            echo "demo $2 error path $IS_PROJECT_DIR";
            exit
        fi
        export PROJ_NAME=$2
        
        # sed -i '5d' Makefile
        # sed -i "5i\LOCAL_LIBS += platform/lib/libinit.a" Makefile
        sed -i '15d' Makefile
        sed -i "15i\LOCAL_MODULE_DEPENDS += project/$2" Makefile
    fi
else
    echo "you can add you own module in the ./Makefile"
    echo "this script usage:"
    echo "use './make.sh PROJECTNAME' to build the project in ./PROJECTNAME";
    echo "use './make.sh demo PROJECTNAME' to build the demo project in ./demo/PROJECTNAME";
    echo "use './make.sh clean PROJECTNAME' to clean the project PROJECTNAME output";
    echo "use './make.sh clean all' to clean all the project output";
    exit
fi

# if [[ ! -d target/$PROJ_NAME ]]; then
#     cp -rf target/init target/$PROJ_NAME
#     echo "user default for init-target";
# fi

#build path and log
LOG_FILE_PATH=$SOFT_WORKDIR/build
if [ ! -d ${LOG_FILE_PATH} ]; then
	mkdir ${LOG_FILE_PATH}
fi
LOG_FILE=${LOG_FILE_PATH}/${PROJ_NAME}_build.log

echo "compile project $PROJ_NAME";
echo "compile path $IS_PROJECT_DIR";

MAKE_J_NUMBER=`cat /proc/cpuinfo | grep vendor_id | wc -l`
cd $SOFT_WORKDIR
if [ ${MAKE_J_NUMBER} -gt 1 ]; then
    make -j${MAKE_J_NUMBER} 2>&1 | tee ${LOG_FILE}
else
    make 2>&1 | tee ${LOG_FILE}
fi

rm -f $SOFT_WORKDIR/hex/*.lod
cp -f $SOFT_WORKDIR/hex/$PROJ_NAME/*.lod $SOFT_WORKDIR/hex
# if [[ "$1x" == "initx" ]]; then
#     cp build/init/init/lib/libinit_*.a platform/lib/libinit.a
# fi

end_time=`date +%s`
time_distance=`expr ${end_time} - ${start_time}`
date_time_now=$(date +%F\ \ %H:%M:%S)
echo ++++ Build Time: ${time_distance}s  at  ${date_time_now} ++++ | tee -a ${LOG_FILE}

exit