
rem note: it is recommended to copy the batches to another local directory
rem because this directory and files will be overwritten when upgraded.

call C:\Progress\OpenEdge110\bin\proenv psc

cd /d C:\Progress\WRK\OpenEdge110



set DB_SET_NAME=test
set BAK_ROOT_DIR=C:\backup

rem set DB<n>=<database>,<optional logical name>,<optional port>
set DB01=C:\Progress\WRK\OpenEdge110\sports2000

set MAIL_HUB=localhost
set MAIL_TO=alonblich@gmail.com
set MAIL_FROM=alonblich@gmail.com



_progres.exe -b -p slib/baksys/backup-aimage.p
