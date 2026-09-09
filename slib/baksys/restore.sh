
# note: it is recommended to copy the scripts to another local directory
# because this directory and files will be overwritten when upgraded.

DLC=/train/dlc92;export DLC
PATH=$DLC/bin:$PATH
WRKDIR=/tmp;export WRKDIR
PROPATH=/p/ssb/prog,.;export PROPATH

# if run from crontab, term might not be set and will cause progress to fail.
TERM=vt100;export TERM

cd $WRKDIR



DB_SET_NAME=ssb;export DB_SET_NAME
ARCHIVE_ROOT_DIR=/archive;export ARCHIVE_ROOT_DIR

# REST_TIME can be set to a specific date and time (like the example below); or
# LAST to restore to the latest point in the archive; or
# PREV to restore to the prev backup (full/incremental) and all after-images.

# if REST_TIME is not set or set to blank then
# PREV will be used if after-images exists (so all after-images of the prev day will be restored and checked); and
# LAST will be used if after-images do not exist.

# REST_TIME=1979-05-18t00-00-00;export REST_TIME
# DISABLE_ROLL_AI=yes;export DISABLE_ROLL_AI

# DB<n>=<new restore database>,<optional logical name>,<optional port>;export DB<n>
DB01=/p/ssb/data/ssbdata;export DB01
DB02=/p/ssb/para/ssbpara;export DB02
DB03=/train/work/ssbwork;export DB03
DB04=/p/hist/history;export DB04

KEEP_ST01=yes;export KEEP_ST01
KEEP_ST02=yes;export KEEP_ST02
KEEP_ST03=yes;export KEEP_ST03
KEEP_ST04=yes;export KEEP_ST04

MAIL_HUB=localhost;export MAIL_HUB
MAIL_TO=alonblich@gmail.com;export MAIL_TO
MAIL_FROM=alonblich@gmail.com;export MAIL_FROM



/p/scripts/ssbstop
sleep 180

_progres -b -p slib/baksys/restore.p

# tail -f $ARCHIVE_ROOT_DIR/restore.lg

sleep 180
/p/scripts/ssbstart
