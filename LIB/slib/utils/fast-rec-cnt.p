
/**
 * fast-rec-cnt.p -
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
 
{slib/slibos.i}

&if "{&opsys}" begins "win" &then

    {slib/slibwin.i}

&else

    {slib/slibunix.i}

&endif

{slib/sliberr.i}

{slib/slibpro.i}



define input    param pcPDbName     as char no-undo.
define input    param pcTableName   as char no-undo.
define output   param piRecCnt      as int no-undo.

define var cIndexName   as char no-undo.
define var cProutil     as char no-undo.
define var cOutFile     as char no-undo.

define var cType        as char no-undo.
define var iEntries     as int no-undo.

define var hQuery       as handle no-undo.
define var hBuffer      as handle no-undo.
define var hBuffer2     as handle no-undo.
define var hBufferField as handle no-undo.

define var cError       as char no-undo.
define var cErrorMsg    as char no-undo.
define var cStackTrace  as char no-undo.

define var str          as char no-undo.



{slib/err_try}:

    create widget-pool.

    if pcPDbName = "" then
       pcPDbName = ?.
    
    if pcTableName = "" then
       pcTableName = ?.
    
    
    
    if pcPDbName = ? then
        {slib/err_throw "'error'" "'Blank database name'"}.

    if os_isRelativePath( pcPDbName ) then
        {slib/err_throw "'error'" "'Physical database ' + pcPDbName + ' cannot be relative path'"}.
    
    if not os_isFileExists( pcPDbName ) then
        {slib/err_throw "'error'" "'Physical database ' + pcPDbName + ' not found'"}.

    if pcTableName = ? then
        {slib/err_throw "'error'" "'Blank table name'"}.

    
    
    connect value( pcPDbName ) -ld SourceDb -Bp 64 {slib/err_no-error-flag}.
    
    create query hQuery.
    
    create buffer hBuffer   for table "SourceDb._file" {slib/err_no-error}.
    create buffer hBuffer2  for table "SourceDb._index" {slib/err_no-error}.
    
    hBufferField = hBuffer2:buffer-field( "_index-name" ).
    
    hQuery:set-buffers( hBuffer, hBuffer2 ).
    hQuery:query-prepare( 
    
        'for each  SourceDb._file ~n' +
            'where SourceDb._file._file-name = "' + pcTableName + '" ~n' +
            'no-lock, ~n' +
    
            'first SourceDb._index ~n' +
            'where recid( SourceDb._index ) = SourceDb._file._prime-index ~n' +
            'no-lock' )
    
                {slib/err_no-error}.
    
    hQuery:query-open( ) {slib/err_no-error}.
    hQuery:get-first( ).
    
    if hQuery:query-off-end then
        {slib/err_throw "'error'" "'Table.index not found'"}.
    
    cIndexName = hBufferField:buffer-value.
    
    hQuery:query-close( ) {slib/err_no-error}.
    


    assign
        cProutil    = os_normalizePath( pro_cDlc + "/bin/proutil" )
        cOutFile    = os_getTempFile( "", ".out" ).
    
    &if "{&opsys}" begins "win" &then
    
        run win_batch(
            input 'call "' + cProutil + '" ' + pcPDbName + ' -C idxblockreport ' 
                + pcTableName + '.' + cIndexName + ' > "' 
                + cOutFile + '"',
    
            input 'silent,wait' ).
    
    &else
    
        run unix_shell( 
            input '"' + cProutil + '" ' + pcPDbName + ' -C idxblockreport ' 
                + pcTableName + '.' + cIndexName + ' > "' 
                + cOutFile + '"',
    
            input 'silent,wait' ).
    
    &endif
    
    
    
    piRecCnt = ?.
    
    if os_isFileExists( cOutFile ) then do:
    
        input from value( cOutFile ).
    
            _main:
    
            repeat:
                    
                do on endkey undo, leave _main:
                    import unformatted str.
                end.
    
                if str matches "*error*" then
                    {slib/err_throw "'error'" str}.
    
                if str begins "DBKEY" then do:
    
                    piRecCnt = 0.
    
                    _data:

                    repeat:
                    
                        do on endkey undo, leave _data:
                            import unformatted str.
                        end.
                    
                        if str matches "*error*" then
                            {slib/err_throw "'error'" str}.
                    
                        if str begins "Index Block Statistics" then
                            leave _data.
    
                        if num-entries( str, chr(9) ) >= 7 then do:

                            assign
                                cType       = trim( entry( 7, str, chr(9) ) )
    
                                iEntries    = ?
                                iEntries    = int( entry( 3, str, chr(9) ) ) no-error.
    
                            if  cType = "leaf" 
                            and iEntries <> ? then

                                piRecCnt = piRecCnt + iEntries.

                        end. /* matches "*leaf*" */
                    
                    end. /* repeat */

                    piRecCnt = piRecCnt - 1.
    
                    leave _main.

                end. /* begins "dbkey" */
    
            end. /* repeat */
                    
        input close. /* cOutFile */
    
    end. /* isfileexists */
    

    
    if piRecCnt = ? then do:
        
        create query hQuery.
    
        create buffer hBuffer for table "SourceDb." + pcTableName {slib/err_no-error}.
    
        hQuery:set-buffers( hBuffer ).
        hQuery:query-prepare( 
    
            "for each SourceDb." + pcTableName + " ~n" +
                "no-lock" ) 
    
                    {slib/err_no-error}.
    
        hQuery:query-open( ) {slib/err_no-error}.
    
        piRecCnt = 0.
        
        do while hQuery:get-next( ):
        
            piRecCnt = piRecCnt + 1.
        
        end. /* do while */
        
        hQuery:query-close( ) {slib/err_no-error}.
    
    end. /* piRecCnt = ? */



{slib/err_catch cError cErrorMsg cStackTrace}:

    message
        cErrorMsg
        skip(1)
        cStackTrace
    view-as alert-box error.



{slib/err_finally}:

    if cOutFile <> "" then
       os-delete value( cOutFile ).

    if connected( "SourceDb" ) then
       disconnect SourceDb no-error.

{slib/err_end}.
