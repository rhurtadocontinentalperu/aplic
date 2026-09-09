
/**
 * obfuscator.p -
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

{slib/slibpro.i}

{slib/sliberr.i}



define input param pcSourceFile as char no-undo.
define input param pcTargetFile as char no-undo.

define temp-table ttLine no-undo

    like pro_ttLine.



define temp-table ttProc no-undo

    field cType     as char
    field cNameOld  as char
    field cNameNew  as char

    index cNameOld is primary unique
          cNameOld.

define temp-table ttDefine no-undo

    field cScope    as char
    field cObject   as char
    field cNameOld  as char
    field cNameNew  as char

    index ScopeNameOld is primary unique
          cScope
          cNameOld.

define temp-table ttName no-undo

    field cNameOld  as char
    field cNameNew  as char

    index cNameNew is unique
          cNameNew.



define var cPreprocessFile as char no-undo init ?.



function getNewName returns char private ( pcNameOld as char ) forward.



{slib/err_try}:

    if os_isRelativePath( pcSourceFile ) then pcSourceFile = os_normalizePath( pro_cWorkDir + "/" + pcSourceFile ).
    if os_isRelativePath( pcTargetFile ) then pcTargetFile = os_normalizePath( pro_cWorkDir + "/" + pcTargetFile ).

    if not os_isFileExists( pcSourceFile ) then
        {slib/err_throw "'file_not_found'" pcSourceFile}.



    run preprocessFile.

    run obfuscateFile.

{slib/err_catch}:

    {slib/err_throw last}.

{slib/err_finally}:

    if cPreprocessFile <> ? then
        os-delete value( cPreprocessFile ).

{slib/err_end}.



procedure preprocessFile private:

    cPreprocessFile = os_getTempFile( "", ".pre" ).

    compile value( pcSourceFile ) preprocess value( cPreprocessFile ) no-error.

end procedure. /* preprocessFile */



procedure obfuscateFile private:

    run pro_parseFile(
        input   cPreprocessFile,
        input   no,
        input   yes,
        output  table ttLine ).

    run obfuscateMain.



    output to value( pcTargetFile ).

    for each ttLine
        use-index iLineNum:

        if ttLine.iLineNum > 1 then
        put unformatted " ".

        put unformatted
            replace( ttLine.cLine, chr(1), "" ).

    end. /* for each ttLine */

    output close. /* pcTargetFile */

end procedure. /* obfuscateFile */

procedure obfuscateMain private:

    define buffer ttLine for ttLine.

    find first ttLine
         use-index iLineNum
         no-error.

    repeat while avail ttLine:

        if ttLine.cLine begins "proc"
        or ttLine.cLine begins "func" then

            run obfuscateProc( buffer ttLine ).

        else
        if ttLine.cLine begins "def" then

            run obfuscateDefine( buffer ttLine, yes ).

        if avail ttLine then do:

            run obfuscateDefineRef( buffer ttLine ).

            find next ttLine
                 use-index iLineNum
                 no-error.

        end. /* avail ttLine */

    end. /* repeat */



    for each ttLine:

        run obfuscateProcRef( buffer ttLine ).

    end. /* for each ttLine */

    for each ttLine:

        run obfuscateString( buffer ttLine ).

    end. /* for each ttLine */

    for each ttLine:
    
        run obfuscateKeyword( buffer ttLine ).

    end. /* for each ttLine */

    for each ttLine:

        run obfuscateLineComment( buffer ttLine ).

    end. /* each ttLine */
    
end procedure. /* obfuscateMain */

procedure obfuscateProc private:

    define param buffer ttLine for ttLine.

    define buffer ttProc    for ttProc.
    define buffer ttDefine  for ttDefine.
    define buffer ttName    for ttName.



    for each  ttDefine
        where ttDefine.cScope = "local"
        use-index ScopeNameOld:
        
        find first ttName
             where ttName.cNameNew = ttDefine.cNameNew
             no-error.

        if avail ttName then
          delete ttName.

        delete ttDefine.

    end. /* for each ttName */

end procedure. /* obfuscateProc */

procedure obfuscateProcRef private:

    define param buffer ttLine for ttLine.

    define buffer ttProc for ttProc.

    define var cWord    as char no-undo.
    define var iWordNum as int no-undo.
    define var iWordCnt as int no-undo.

    iWordCnt = num-entries( ttLine.cLine, chr(1) ).
    do iWordNum = 1 to iWordCnt:

        cWord = entry( iWordNum, ttLine.cLine, chr(1) ).
        if cWord = " " then next.

        if  substr( cWord, 1, 1 ) >= "a"
        and substr( cWord, 1, 1 ) <= "z" then do:

            find first ttProc
                 where ttProc.cNameOld = cWord
                 use-index cNameOld
                 no-error.   

            if avail ttProc then
                entry( iWordNum, ttLine.cLine, chr(1) ) = ttProc.cNameNew.

        end. /* substr >= "a" and substr <= "z" */

    end. /* do iPos */

end procedure. /* obfuscateProcRef */

procedure obfuscateDefine private:

    define param buffer ttLine  for ttLine.
    define input param  pcScope as char no-undo.

    define buffer ttDefine  for ttDefine.
    define buffer ttName    for ttName.

    define var cNameOld as char no-undo.
    define var cNameNew as char no-undo.

    define var iLen     as int no-undo.
    define var str      as char no-undo.
    
    iLen = num-entries( ttLine.cLine, chr(1) ).

    if  iLen >= 1
    and "define" begins entry( 1, ttLine.cLine, chr(1) )
    and entry( 1, ttLine.cLine, chr(1) ) begins "def" then do:

        if  iLen >= 2 
        and entry( 2, ttLine.cLine, chr(1) ) = " " then do:

            if iLen >= 3 then do:
            if  "variable" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "var" then do:

                if  iLen >= 4
                and entry( 4, ttLine.cLine, chr(1) ) = " "

                and iLen >= 5
                and entry( 5, ttLine.cLine, chr(1) ) <> " " then do:

                    if  iLen >= 6
                    and entry( 6, ttLine.cLine, chr(1) ) = " "

                    and iLen >= 7
                    and "like" begins entry( 7, ttLine.cLine, chr(1) )
                    and entry( 7, ttLine.cLine, chr(1) ) begins "like"

                    and iLen >= 8
                    and entry( 8, ttLine.cLine, chr(1) ) = " "

                    and iLen >= 9
                    and entry( 9, ttLine.cLine, chr(1) ) <> " " then do:

                        find first ttDefine
                             where ttDefine.cScope      = "local"
                               and ttDefine.cNameOld    = entry( 9, ttLine.cLine, chr(1) )
                             use-index ScopeNameOld
                             no-error.   

                        if not avail ttDefine then

                        find first ttDefine
                             where ttDefine.cScope      = "global"
                               and ttDefine.cNameOld    = entry( 9, ttLine.cLine, chr(1) )
                             use-index ScopeNameOld
                             no-error.

                        if avail ttDefine then
                            entry( 9, ttLine.cLine, chr(1) ) = ttDefine.cNameNew.

                    end. /* "like" begins entry */

                    assign
                        cNameOld    = entry( 5, ttLine.cLine, chr(1) )
                        cNameNew    = getNewName( cNameOld )
                        
                        entry( 5, ttLine.cLine, chr(1) ) = cNameNew.

                    create ttDefine.
                    assign
                        ttDefine.cScope     = pcScope
                        ttDefine.cObject    = "var"
                        ttDefine.cNameOld   = cNameOld
                        ttDefine.cNameNew   = cNameNew.

                    find next ttLine
                         use-index iLineNum
                         no-error.

                end. /* iLen >= 4 */

            end. /* "variable" begins entry */



            else
            if  "buffer" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "buf" then do:

                if  iLen >= 4
                and entry( 4, ttLine.cLine, chr(1) ) = " "

                and iLen >= 5
                and entry( 5, ttLine.cLine, chr(1) ) <> " "

                and iLen >= 6
                and entry( 6, ttLine.cLine, chr(1) ) = " "

                and iLen >= 7
                and "for" begins entry( 7, ttLine.cLine, chr(1) )
                and entry( 7, ttLine.cLine, chr(1) ) begins "for"

                and iLen >= 8
                and entry( 8, ttLine.cLine, chr(1) ) = " "

                and iLen >= 9
                and entry( 9, ttLine.cLine, chr(1) ) <> " " then do:

                    /***
                    find first ttName
                         where ttName.cType     = "define"
                           and ttName.cScope    = "global"
                           and ttName.cNameOld  = str
                           and ttName.cObject   = "temp-table"
                         use-index TypeScopeNameOld
                         no-error.

                    if avail ttName then
                        entry( 9, ttLine.cLine, chr(1) ) = ttName.cNameNew.

                    assign
                        cNameOld = entry( 5, ttLine.cLine, chr(1) )
                        cNameNew = getNewName( )

                        entry( 5, ttLine.cLine, chr(1) ) = cNameNew.

                    create ttName.
                    assign
                        ttName.cType    = "define"
                        ttName.cScope   = pcScope
                        ttName.cObject  = "buffer"
                        ttName.cNameOld = cNameOld
                        ttName.cNameNew = cNameNew.

                    find next ttLine
                         use-index iLineNum
                         no-error.
                    ***/

                end. /* "for" begins entry */

            end. /* "buffer" begins entry */



            else
            if  "temp-table" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "temp-table"

             or "work-table" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "work-table"

             or "workfile" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "workfile" then do:



            end. /* "temp-table" begins entry */



            else
            if  "input" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "inp"

             or "output" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "out"

             or "input-output" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "input-output" then do:



            end. /* "input" begins entry */



            else
            if  "parameter" begins entry( 3, ttLine.cLine, chr(1) )
            and entry( 3, ttLine.cLine, chr(1) ) begins "para" then do:

                if  iLen >= 4
                and "buffer" begins entry( 4, ttLine.cLine, chr(1) )
                and entry( 4, ttLine.cLine, chr(1) ) begins "buf"

                and iLen >= 5
                and entry( 5, ttLine.cLine, chr(1) ) = " "

                and iLen >= 6
                and entry( 6, ttLine.cLine, chr(1) ) <> " "

                and iLen >= 7
                and entry( 7, ttLine.cLine, chr(1) ) = " "

                and iLen >= 8
                and "for" begins entry( 7, ttLine.cLine, chr(1) )
                and entry( 8, ttLine.cLine, chr(1) ) begins "for"

                and iLen >= 9
                and entry( 9, ttLine.cLine, chr(1) ) = " "

                and iLen >= 10
                and entry( 10, ttLine.cLine, chr(1) ) <> " " then do:

                    /***
                    find first ttName
                         where ttName.cType     = "define"
                           and ttName.cScope    = "global"
                           and ttName.cNameOld  = str
                           and ttName.cObject   = "temp-table"
                         use-index TypeScopeNameOld
                         no-error.

                    if avail ttName then
                        entry( 9, ttLine.cLine, chr(1) ) = ttName.cNameNew.

                    assign
                        cNameOld = entry( 5, ttLine.cLine, chr(1) )
                        cNameNew = getNewName( )

                        entry( 5, ttLine.cLine, chr(1) ) = cNameNew.

                    create ttName.
                    assign
                        ttName.cType    = "define"
                        ttName.cScope   = pcScope
                        ttName.cObject  = "buffer"
                        ttName.cNameOld = cNameOld
                        ttName.cNameNew = cNameNew.

                    find next ttLine
                         use-index iLineNum
                         no-error.
                    ***/                     

                end. /* "for" begins entry */

            end. /* "parameter" begins entry */

            end. /* iLen >= 3 */

        end. /* entry = " " */

    end. /* "define" begins entry */

end procedure. /* obfuscateDefine */

procedure obfuscateDefineRef private:

    define param buffer ttLine  for ttLine.
    define input param  pcScope as char no-undo.

    define buffer ttDefine for ttDefine.

    define var cWord    as char no-undo.
    define var cWordNew as char no-undo.
    define var iWordNum as int no-undo.
    define var iWordCnt as int no-undo.

    define var iLen     as int no-undo.
    define var iPos     as int no-undo.

    define var str      as char no-undo.
    define var ch       as char no-undo.
    define var i        as int no-undo.

    iWordCnt = num-entries( ttLine.cLine, chr(1) ).
    do iWordNum = 1 to iWordCnt:

        cWord = entry( iWordNum, ttLine.cLine, chr(1) ).
        if cWord = " " then next.

        if  substr( cWord, 1, 1 ) >= "a"
        and substr( cWord, 1, 1 ) <= "z" then do:

            find first ttDefine
                 where ttDefine.cScope      = "local"
                   and ttDefine.cNameOld    = cWord
                 use-index ScopeNameOld
                 no-error.

            if not avail ttDefine then

            find first ttDefine
                 where ttDefine.cScope      = "global"
                   and ttDefine.cNameOld    = cWord
                 use-index ScopeNameOld
                 no-error.

            if avail ttDefine then
                entry( iWordNum, ttLine.cLine, chr(1) ) = ttDefine.cNameNew.

        end. /* substr >= "a" and substr <= "z" */

    end. /* do iPos */

end procedure. /* obfuscateDefineRef */

procedure obfuscateKeyword private:

    define param buffer ttLine for ttLine.

    define var cWord    as char no-undo.
    define var iWordNum as int no-undo.
    define var iWordCnt as int no-undo.

    iWordCnt = num-entries( ttLine.cLine, chr(1) ).
    do iWordNum = 1 to iWordCnt:

        cWord = entry( iWordNum, ttLine.cLine, chr(1) ).
        if cWord = " " then next.

        if "define" begins cWord and cWord begins "def" then
            entry( iWordNum, ttLine.cLine, chr(1) ) = "def".

        else
        if "variable" begins cWord and cWord begins "var" then
            entry( iWordNum, ttLine.cLine, chr(1) ) = "var".

        else
        if cWord = "as" then
            entry( iWordNum, ttLine.cLine, chr(1) ) = "as".

        else
        if "character" begins cWord and cWord begins "char" then
            entry( iWordNum, ttLine.cLine, chr(1) ) = "c".

        else
        if "integer" begins cWord and cWord begins "int" then
            entry( iWordNum, ttLine.cLine, chr(1) ) = "i".

        else
        if "decimal" begins cWord and cWord begins "dec" then
            entry( iWordNum, ttLine.cLine, chr(1) ) = "d".

        else
        if "logical" begins cWord and cWord begins "log" then
            entry( iWordNum, ttLine.cLine, chr(1) ) = "l".

        else
        if "date" begins cWord and cWord begins "da" then
            entry( iWordNum, ttLine.cLine, chr(1) ) = "da".

        else
        if lookup( cWord, "=,<>,>,<,>=,<=" ) > 0 then do:
        
            if  iWordNum - 1 >= 1
            and entry( iWordNum - 1, ttLine.cLine, chr(1) ) <> " " then
                entry( iWordNum - 1, ttLine.cLine, chr(1) ) = entry( iWordNum - 1, ttLine.cLine, chr(1) ) + chr(1) + " ".

            case cWord:

                when "="    then entry( iWordNum, ttLine.cLine, chr(1) ) = "eq".
                when "<>"   then entry( iWordNum, ttLine.cLine, chr(1) ) = "ne".
                when ">"    then entry( iWordNum, ttLine.cLine, chr(1) ) = "gt".
                when "<"    then entry( iWordNum, ttLine.cLine, chr(1) ) = "lt".
                when ">="   then entry( iWordNum, ttLine.cLine, chr(1) ) = "ge".
                when "<="   then entry( iWordNum, ttLine.cLine, chr(1) ) = "le".

            end case. /* cWord */

            if  iWordNum + 1 <= iWordCnt
            and entry( iWordNum + 1, ttLine.cLine, chr(1) ) <> " " then
                entry( iWordNum + 1, ttLine.cLine, chr(1) ) = " " + chr(1) + entry( iWordNum - 1, ttLine.cLine, chr(1) ).

        end. /* lookup( ) > 0 */

    end. /* do iPos */

end procedure. /* obfuscateKeyword */

procedure obfuscateString private:

    define param buffer ttLine for ttLine.

    define var cWord    as char no-undo.
    define var cWordNew as char no-undo.
    define var iWordNum as int no-undo.
    define var iWordCnt as int no-undo.

    define var iLen     as int no-undo.
    define var iPos     as int no-undo.

    define var str      as char no-undo.
    define var ch       as char no-undo.
    define var i        as int no-undo.

    iWordCnt = num-entries( ttLine.cLine, chr(1) ).
    do iWordNum = 1 to iWordCnt:

        if cWord begins '"'
        or cWord begins "'" then do:

            assign
                cWordNew    = ""
                iLen        = length( cWord )
                iPos        = 1

                cWordNew    = substr( cWord, iPos, 1 )
                iPos        = iPos + 1.

            repeat while iPos <= iLen - 1:

                ch = substr( cWord, iPos, 1 ).

                if  ch = "~~"
                and substr( cWord, iPos + 1, 1 ) >= "0" and substr( cWord, iPos + 1, 1 ) <= "9"
                and substr( cWord, iPos + 2, 1 ) >= "0" and substr( cWord, iPos + 2, 1 ) <= "9"
                and substr( cWord, iPos + 3, 1 ) >= "0" and substr( cWord, iPos + 3, 1 ) <= "9" then do:

                    assign
                        cWordNew    = cWordNew + substr( cWord, iPos, 4 )
                        iPos        = iPos + 4.

                end. /* ch = "~~" */

                else
                if ch = "~~" or ch = "~\" and opsys = "unix" then do:

                    assign
                        cWordNew    = cWordNew + substr( cWord, iPos, 2 )
                        iPos        = iPos + 2.
                
                end. /* ch = "~~" */

                else do:

                    case ch:

                        when "~n" then str = "~~n".
                        when "~r" then str = "~~r".
                        when "~f" then str = "~~f".
                        when "~t" then str = "~~t".
                        when "~b" then str = "~~b".
                        when "~E" then str = "~~E".

                        otherwise do:

                            assign
                                i = asc( ch )

                                str = string( i mod 8, "9" )        i = ( i - i mod 8 ) / 8
                                str = string( i mod 8, "9" ) + str  i = ( i - i mod 8 ) / 8
                                str = string( i,       "9" ) + str

                                str = "~~" + str.

                        end. /* otherwise */

                    end case. /* ch */

                    assign
                        cWordNew    = cWordNew + str
                        iPos        = iPos + 1.

                end. /* else */
                
            end. /* repeat */

            assign            
                cWordNew    = cWord + substr( cWord, iPos, 1 )
                iPos        = iPos + 1

                entry( iWordNum, ttLine.cLine, chr(1) ) = cWordNew.

        end. /* begins '"' */

    end. /* do iPos */

end procedure. /* obfuscateString */

procedure obfuscateLineComment private:

    define param buffer ttLine for ttLine.



end procedure. /* obfuscareLineComment */



function getNewName returns char private ( 

    input pcType    as char,
    input pcNameOld as char ):

    &scoped xDefineNameList 'x,y,z,iii,jjj,ttt,aaa,bbb,ccc,fff,my_var,val,test,test_test,dummy,ref,ref_ref,var,auto,gen,project'

    define buffer ttName for ttName.

    define var str  as char no-undo.
    define var i    as int no-undo.
    define var j    as int no-undo.

    repeat:



        if not can-find(
            first ttName
            where ttName.cNameNew = str
            use-index cNameNew ) then do:
            
            create ttName.
            assign
                ttName.cNameOld = pcNameOld
                ttName.cNameNew =  cNameNew.
                
            leave.

        end. /* not can-find */

    end. /* repeat */

    return str.

    &undefine xCharList
    &undefine xLen

end function. /* getNewName */

/***
function getNewName returns char private ( pcNameOld as char ):

    &scoped xCharList   'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
    &scoped xLen        63

    define buffer ttName for ttName.

    define var str  as char no-undo.
    define var i    as int no-undo.
    define var j    as int no-undo.

    repeat:

        j = random( 20, 30 ).

        repeat:

            str = substr( {&xCharList}, random( 1, {&xLen} ), 1 ).
            if str >= "a" and str <= "z" then leave.

        end. /* repeat */

        do i = 2 to j:

            str = str + substr( {&xCharList}, random( 1, {&xLen} ), 1 ).

        end. /* do i */

        if not can-find(
            first ttName
            where ttName.cNameNew = str
            use-index cNameNew ) then do:
            
            create ttName.
            assign
                ttName.cNameOld = pcNameOld
                ttName.cNameNew =  cNameNew.
                
            leave.

        end. /* not can-find */

    end. /* repeat */

    return str.

    &undefine xCharList
    &undefine xLen

end function. /* getNewName */
***/

