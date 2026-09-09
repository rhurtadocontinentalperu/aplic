
# note: it is recommended to copy the scripts to another local directory
# because this directory and files will be overwritten when upgraded.

DLC=/train/dlc92;export DLC
PATH=$DLC/bin:$PATH
WRKDIR=/tmp;export WRKDIR
PROPATH=/p/ssb/prog,.;export PROPATH

# if run from crontab, term might not be set and will cause progress to fail.
TERM=vt100;export TERM

cd $WRKDIR



# note: it is recommended to use chown and chmod on both the production and development dir (includign sub-dirs)
# so all users can save files and update the repository (.svn dirs).

chown -R progress:progress /p/ssb/prog/*
chmod -R ugo+r+w /p/ssb/prog/*

chown -R progress:progress /develop/p/ssb/prog/*
chmod -R ugo+r+W /develop/p/ssb/prog/*



_progres -b -p slib/svnhook/svn_auto_update.p -param "/p/scripts,/p/ssb/prog" > /dev/null
