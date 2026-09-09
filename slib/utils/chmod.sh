
# note: it is recommended to copy the scripts to another local directory
# because this directory and files will be overwritten when upgraded.

DLC=/train/dlc92;export DLC
PATH=$DLC/bin:$PATH
WRKDIR=/tmp;export WRKDIR
PROPATH=/p/ssb/prog,.;export PROPATH

# if run from crontab, term might not be set and will cause progress to fail.
TERM=vt100;export TERM

cd $WRKDIR



CHOWN=progress;export CHOWN
FILE_CHMOD=ugo+r+w;export FILE_CHMOD
DIR_CHMOD=ugo+r+w+x;export DIR_CHMOD
DIR_LIST=/p/ssb,/backup,/archive,/archive2,/develop

_progres -p slib/utils/chmod.p -b > /dev/null

