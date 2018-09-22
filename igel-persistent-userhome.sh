#!/bin/bash

PERSISTENT_DIRECTORIES=$'C:\Users\Administrator
.java
.oracle_jre_usage
.javaws
.jpi_cache
.local
.cache
.config'

PERSISTENT_FILES=$'.rmconsole.cert'
SOURCEPATH='/userhome'
DESTPATH='/custom/persistent'
LOGGERNAME="${0%%.sh}"


check_custom_partition () {
	if [ ! -d /custom ] ; then
		logger -t "${LOGGERNAME}-${FUNCNAME[0]}" "No custom partition found"
		exit 1
	fi
}

create_destpath () {
	if [ ! -d "$DESTPATH" ]; then
		mkdir "$DESTPATH"
		chown user:users "$DESTPATH"
		logger -t "${LOGGERNAME}-${FUNCNAME[0]}" "created $DESTPATH directory"
	fi
}

first_move () {
	
	while read -r mypath; do	

		if [ -d "$SOURCEPATH/$mypath" ] && [ ! -L "$SOURCEPATH/$mypath" ]; then
			mv "$SOURCEPATH/$mypath" "$DESTPATH"
			ln -s "$DESTPATH/$mypath" "$SOURCEPATH/$mypath"
			logger -t "${LOGGERNAME}-${FUNCNAME[0]}" "moved $SOURCEPATH/$mypath $DESTPATH"
			logger -t "${LOGGERNAME}-${FUNCNAME[0]}" "linked $DESTPATH/$mypath $SOURCEPATH/$mypath"
		fi
	done <<< "$PERSISTENT_DIRECTORIES"

	while read -r mypath; do	

		if [ -f "$SOURCEPATH/$mypath" ] && [ ! -L "$SOURCEPATH/$mypath" ]; then
			mv "$SOURCEPATH/$mypath" "$DESTPATH"
			ln -s "$DESTPATH/$mypath" "$SOURCEPATH/$mypath"
			logger -t "${LOGGERNAME}-${FUNCNAME[0]}" "moved $SOURCEPATH/$mypath $DESTPATH"
			logger -t "${LOGGERNAME}-${FUNCNAME[0]}" "linked $DESTPATH/$mypath $SOURCEPATH/$mypath"
		fi
	done <<< "$PERSISTENT_FILES"

}

make_symlinks () {
 
	while read -r mypath; do
		if [ -d "$DESTPATH/$mypath" ]; then
			ln -sf "$DESTPATH/$mypath" "$SOURCEPATH/$mypath"
			logger -t "${LOGGERNAME}-${FUNCNAME[0]}" "linked $DESTPATH/$mypath $SOURCEPATH/$mypath"
		fi
	done <<< "$PERSISTENT_DIRECTORIES"

	while read -r mypath; do
		if [ -f "$DESTPATH/$mypath" ]; then
			ln -sf $DESTPATH/$mypath $SOURCEPATH/$mypath
			logger -t ${LOGGERNAME}-${FUNCNAME[0]} "linked $DESTPATH/$mypath $SOURCEPATH/$mypath"
		fi
	done <<< "$PERSISTENT_FILES"

}

check_custom_partition
create_destpath
first_move
make_symlinks
