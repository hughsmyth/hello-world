#!/bin/sh
## Archive log file and purge ones over 90 days old
## Cron entry 19 2 * * * (. /home/<instance>/sqllib/db2profile; ~/pruneDb2diag.sh 2>> ~/log/pruneDb2diagError.log)

##
## purge files over this age
##
# AGE=92
AGE=93

. ~/DBscriptConfig

DIAGPATH=$(db2 get dbm cfg | grep -E '\(DIAGPATH\)' | cut -d '=' -f2 | sed 's/ *//g' )
if [ -z "$DIAGPATH" ]; then 
	echo "Error: can't resolve DIAGPATH from db2 get dbm cfg"
	exit 1
fi

if [ ! -d "$DIAGPATH" ]; then
	echo "Error: DIAGPATH $DIAGPATH does not exist"
	exit 1
fi

cd "$DIAGPATH"
rc=$?
if [ $rc -ne 0 ]; then
	echo "Error: there was an error changing to $DIAGPATH"
	exit 1
fi

## archive db2diag
db2diag -A -readfile db2diag.log

## remove files
find . -name 'db2diag.log*' -mtime +$AGE -exec rm {} \;


