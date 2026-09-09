
# note: it is recommended to copy the scripts to another local directory
# because this directory and files will be overwritten when upgraded.

# note: the baksys has 2 main scenarios -
#
# 1. backup and archive are stored on the same machine.
# in this scenario the backup and archive are runned together
# so after a backup has completed it will be stored to archive immediately.
#
# 2. backup on production machine and archive on test or backup machine.
# in this scenario the backup and archive run on separate machines.

DLC=/train/dlc92;export DLC
PATH=$DLC/bin:$PATH
WRKDIR=/tmp;export WRKDIR
PROPATH=/p/ssb/prog,.;export PROPATH

# if run from crontab, term might not be set and will cause progress to fail.
TERM=vt100;export TERM

cd $WRKDIR



DB_SET_NAME=ssb;export DB_SET_NAME
BAK_ROOT_DIR=/backup;export BAK_ROOT_DIR
ARCHIVE_ROOT_DIR=/archive;export ARCHIVE_ROOT_DIR
ARCHIVE_VERSIONS=1;export ARCHIVE_VERSIONS

# DB<n>=<database>,<optional logical name>,<optional port>;export DB<n>
DB01=/p/ssb/data/ssbdata;export DB01
DB02=/p/ssb/para/ssbpara;export DB02
DB03=/train/work/ssbwork;export DB03
DB04=/p/hist/history;export DB04

MAIL_HUB=localhost;export MAIL_HUB
MAIL_TO=alonblich@gmail.com;export MAIL_TO
MAIL_FROM=alonblich@gmail.com;export MAIL_FROM



_progres -b -p slib/baksys/archive.p

# tail -f $ARCHIVE_ROOT_DIR/archive.lg
