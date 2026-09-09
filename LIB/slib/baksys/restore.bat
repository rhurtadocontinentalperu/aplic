
rem note: it is recommended to copy the batches to another local directory
rem because this directory and files will be overwritten when upgraded.

call C:\Progress\OpenEdge110\bin\proenv psc

cd /d C:\Progress\WRK\OpenEdge110



set DB_SET_NAME=test
set ARCHIVE_ROOT_DIR=C:\archive

rem REST_TIME can be set to a specific date and time (like the example below); or
rem LAST to restore to the latest point in the archive; or
rem PREV to restore to the prev backup (full/incremental) and all after-images.

rem if REST_TIME is not set or set to blank then
rem PREV will be used if after-images exists (so all after-images of the prev day will be restored and checked); and
rem LAST will be used if after-images do not exists.

rem set REST_TIME=1979-05-18t23-59-59
rem set DISABLE_ROLL_AI=yes

rem set DB<n>=<new restore database>,<optional logical name>,<optional port>
set DB01=C:\restore\sports2000\sports2000

rem set KEEP_ST01=yes

set MAIL_HUB=localhost
set MAIL_TO=alonblich@gmail.com
set MAIL_FROM=alonblich@gmail.com



rem call stopdb script

_progres.exe -b -p slib/baksys/restore.p

rem call startdb script
