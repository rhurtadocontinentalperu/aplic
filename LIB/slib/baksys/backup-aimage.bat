
rem note: it is recommended to copy the batches to another local directory
rem because this directory and files will be overwritten when upgraded.

rem note: the baksys has 2 main scenarios -
rem
rem 1. backup and archive are stored on the same machine.
rem in this scenario the backup and archive are runned together
rem so after a backup has completed it will be stored to archive immediately.
rem
rem 2. backup on production machine and archive on test or backup machine.
rem in this scenario the backup and archive run on separate machines.

call C:\Progress\OpenEdge110\bin\proenv psc

cd /d C:\Progress\WRK\OpenEdge110



set DB_SET_NAME=test
set BAK_ROOT_DIR=C:\backup

rem for scenario 1
rem set ARCHIVE_ROOT_DIR=C:\archive
rem set ARCHIVE_VERSIONS=1

rem set DB<n>=<database>,<optional logical name>,<optional port>
set DB01=C:\Progress\WRK\OpenEdge110\sports2000

set MAIL_HUB=localhost
set MAIL_TO=alonblich@gmail.com
set MAIL_FROM=alonblich@gmail.com



_progres.exe -b -p slib/baksys/backup-aimage.p

rem for scenario 1
rem _progres.exe -b -p slib/baksys/archive-aimage.p
