#!/usr/bin/env bash

function miner_ver() {
	local MINER_VER=$CRYPTODREDGE_VER
	if [[ -z $MINER_VER ]]; then
		MINER_VER=$MINER_LATEST_VER
		[[ ! -z $MINER_LATEST_VER_CUDA11 && $(nvidia-smi --help 2>&1 | head -n 1 | grep -oP "v\K[0-9]+") -ge 455 ]] && 
			MINER_VER=$MINER_LATEST_VER_CUDA11
		[[ ! -z $MINER_LATEST_VER_UBU16 && $(lsb_release  -c) =~ xenial ]] &&
			MINER_VER=$MINER_LATEST_VER_UBU16
	fi
	echo $MINER_VER
}


function miner_config_echo() {
	local MINER_VER=`miner_ver`
	miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/$MINER_NAME.conf"
}

function miner_config_gen() {

	local MINER_CONFIG="$MINER_DIR/$MINER_VER/$MINER_NAME.conf"
	mkfile_from_symlink $MINER_CONFIG

	local algo=${CRYPTODREDGE_ALGO}
	case ${algo} in
		"cryptonight-lite-v7" )
			algo="aeon"
		;;
		"cryptonight-fast" )
			algo="cnfast"
		;;
		"cryptonight-heavy" )
			algo="cnheavy"
		;;
		"cryptonight-v7" )
			algo="cnv7"
		;;
		"cryptonight-xhv" )
			algo="cnhaven"
		;;
		"cryptonight-saber" )
			algo="cnsaber"
		;;
		"cryptonight-v8" )
			algo="cnv8"
		;;
		"cryptonight" )
			algo="cnv8"
		;;
		"cryptonight-xtl" )
			algo="stellite"
		;;
		"cryptonight-fast-v8" )
			algo="cnfast2"
		;;
		"cryptonight-superfast" )
			algo="cnsuperfast"
		;;
		"cryptonight-gpu" )
			algo="cngpu"
		;;
		"cryptonight-tlo" )
			algo="cntlo"
		;;
		"cryptonight-trtl" )
			algo="cnturtle"
		;;
		"cryptonight-ccx" )
			algo="cnconceal"
		;;
		"cryptonight-upx2" )
			algo="cnupx2"
		;;
		"cryptonight-zls" )
			algo="cnzls"
		;;
	esac
	[[ ! -z ${algo} ]] && algo="-a ${algo}"

	local pool=`head -n 1 <<< "$CRYPTODREDGE_URL"`

	[[ -z $CRYPTODREDGE_PASS ]] && CRYPTODREDGE_PASS="x"

	conf="${algo} -o $pool -u ${CRYPTODREDGE_TEMPLATE} -p ${CRYPTODREDGE_PASS} ${CRYPTODREDGE_USER_CONFIG}"

	echo "$conf" > $MINER_CONFIG
}
