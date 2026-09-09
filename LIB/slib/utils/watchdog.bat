
rem note: it is recommended to copy the batches to another local directory
rem because this directory and files will be overwritten when upgraded.

call C:\Progress\OpenEdge110\bin\proenv psc

cd /d C:\Progress\WRK\OpenEdge110



_progres -p slib/utils/watchdog.p -b -db /p/ssb/data/ssbdata -db /p/ssb/para/ssbpara -db /train/work/ssbwork -db /p/hist/history > nil

