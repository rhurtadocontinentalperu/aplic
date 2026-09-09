
# note: it is recommended to copy the scripts to another local directory
# because this directory and files will be overwritten when upgraded.

DLC=/train/dlc92;export DLC
PATH=$DLC/bin:$PATH
WRKDIR=/tmp;export WRKDIR
PROPATH=/p/ssb/prog,.;export PROPATH

# if run from crontab, term might not be set and will cause progress to fail.
TERM=vt100;export TERM

cd $WRKDIR



_progres -p slib/utils/watchdog.p -b -db /p/ssb/data/ssbdata -db /p/ssb/para/ssbpara -db /train/work/ssbwork -db /p/hist/history > /dev/null

