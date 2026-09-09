
/**
 * create-bin-load.p -
 *
 * (c) Copyright ABC Alon Blich Consulting Tech, Ltd.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 *  Contact information
 *  Email: alonblich@gmail.com
 *  Phone: +263-77-7600818
 */

&global xLDbName    history
&global xPDbName    /turbo/db/{&xLDbName}/{&xLDbName}
&global xSrtFile    {&xPDbName}.srt
&global xScriptFile /p/scripts/ssb-idxbuild-{&xLDbName}-turbo
&global xLogFile    ./idxbuild-{&xLDbName}.lg



{slib/slibpro.i}

output to '{&xScriptFile}'.

put unformatted
    '#!/bin/ksh' skip
    skip(1)
    'DLC=' + pro_cDlc + ';export DLC' skip
    'PATH=$DLC/bin:$PATH' skip
    'WRKDIR=' + pro_cWorkDir + ';export WRKDIR' skip
    skip(1)
    '# if run from crontab, term might not be set and will cause progress to fail.' skip
    'TERM=vt100;export TERM' skip
    skip(1)
    'cd $WRKDIR' skip
    skip(1)
    'rm -f {&xLogFile}' skip
    skip(1).
   
put unformatted
      'proutil {&xPDbName}'
    + ' -C idxbuild all'
    + ' -SS {&xSrtFile}'
    + ' -TB 31'
    + ' -TM 32'
&if {&pro_xProversion} >= "10" &then
    + ' -pfacor 80'
&endif
    + ' -T ' + pro_cWorkDir
    + ' > {&xLogFile}'
    skip.

put unformatted
    skip(1).

output close.

