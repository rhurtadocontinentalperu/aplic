
/**
 * slibqry.p -
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

{slib/slibqryprop.i}

{slib/slibpro.i}

{slib/sliberr.i}



on "close" of this-procedure do:

    delete procedure this-procedure.

end. /* close */

procedure initializeProc:

end procedure. /* initializeProc */



procedure qry_parseQuery:

    define input param pcQueryPhrase as char no-undo.

    empty temp-table qry_ttQuery.
    empty temp-table qry_ttRecordPhrase.
    empty temp-table qry_ttBuffer.
    empty temp-table qry_ttWhereTree.
    empty temp-table qry_ttEquiJoinField.
    empty temp-table qry_ttLiteral.

    run parseQuery( pcQueryPhrase ).

end procedure. /* qry_parseQuery */



procedure parseQuery private:

    define input param pcQueryPhrase as char no-undo.

    define buffer qry_ttQuery for qry_ttQuery.

    define var cQuery               as char no-undo.
    define var cRecordPhraseList    as char no-undo.
    define var cQueryTuning         as char no-undo.
    define var lBreak               as log no-undo.
    define var cByExpList           as char no-undo.
    define var cByDescendList       as char no-undo.
    define var lIndexedReposition   as log no-undo.
    define var cMaxRows             as char no-undo.

    define var iRecordPhraseCnt     as int no-undo.
    define var iRecordPhrase        as int no-undo.
    define var cRecordPhrase        as char no-undo.

    define var cKeywordPhraseList   as char no-undo.
    define var iKeywordPhraseCnt    as int no-undo.
    define var cKeywordPhrase       as char no-undo.
    define var iKeywordPhrase       as int no-undo.
    define var cKeyword             as char no-undo.
    define var cPhrase              as char no-undo.
    define var cExp                 as char no-undo.
    define var cDescend             as char no-undo.

    define var str                  as char no-undo.
    define var idx                  as int no-undo.
    define var i                    as int no-undo.
    define var j                    as int no-undo.

    assign
        cQuery             = ?
        cRecordPhraseList  = ?
        cQueryTuning       = ?
        lBreak             = no
        cByExpList         = ?
        cByDescendList     = ?
        lIndexedReposition = no
        cMaxRows           = ?.



    assign
       cKeywordPhraseList   = pro_parseKeywordPhraseList(

            input pcQueryPhrase,
            input "for,~~,|preselect,~~,|query-tuning|break|by,by|indexed-reposition|max-rows" )

       iKeywordPhraseCnt    = num-entries( cKeywordPhraseList, chr(1) ).

    if cKeywordPhraseList = "" then
        {slib/err_throw "'qry_unable_to_understand'" pcQueryPhrase}.



    assign
        cKeywordPhrase      = entry( 1, cKeywordPhraseList, chr(1) )
        cKeyword            = entry( 1, cKeywordPhrase, chr(2) )
        cPhrase             = entry( 2, cKeywordPhrase, chr(2) ).

    if cKeyword <> "for" and cKeyword <> "preselect" then
        {slib/err_throw "'qry_unable_to_understand'" pcQueryPhrase}.

    if cPhrase = "" then
        {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

    assign
        cQuery             = cKeyword
        cRecordPhraseList  = replace( cPhrase, chr(3), chr(1) ).



    do iKeywordPhrase = 2 to iKeywordPhraseCnt:

        assign
            cKeywordPhrase  = entry( iKeywordPhrase, cKeywordPhraseList, chr(1) )
            cKeyword        = entry( 1, cKeywordPhrase, chr(2) )
            cPhrase         = entry( 2, cKeywordPhrase, chr(2) ).

        case cKeyword:

            when "query-tuning" then do:

                if cQueryTuning <> ? then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase = "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if not cPhrase matches "(*)" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                cQueryTuning = cPhrase.

            end. /* query-tuning */

            when "break" then do:

                if lBreak <> no then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase <> "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                lBreak = yes.

            end. /* break */

            when "by" then do:

                if cByExpList <> ? then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase = "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                j = num-entries( cPhrase, chr(3) ). do i = 1 to j:

                    cExp = entry( i, cPhrase, chr(3) ).

                    if cExp = "" then
                        {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                    cDescend = "".

                    idx = r-index( cExp, " " ).
                    if idx > 0 then

                        cDescend = substr( cExp, idx + 1 ).

                    if  "descending" begins cDescend
                    and length( cDescend ) >= 4 then do:

                    &if {&pro_xProversion} >= "10" &then
                        if compare( "DESCENDING", "begins", cDescend, "raw" ) then
                        cDescend = "DESCENDING".

                        else
                        if compare( "descending", "begins", cDescend, "raw" ) then
                        cDescend = "descending".

                        else
                    &endif

                        cDescend = "descending".

                        cExp = right-trim( substr( cExp, 1, idx - 1 ) ).

                    end. /* idx > 0 */

                    if cByExpList = ? then
                    assign
                        cByExpList     = cExp
                        cByDescendList = cDescend.

                    else
                    assign
                        cByExpList     = cByExpList       + chr(1) + cExp
                        cByDescendList = cByDescendList   + chr(1) + cDescend.

                end. /* 1 to iByCnt */

            end. /* by */

            when "indexed-reposition" then do:

                if lIndexedReposition <> no then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase <> "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                lIndexedReposition = yes.

            end. /* indexed-reposition */

            when "max-rows" then do:

                if cMaxRows <> ? then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase = "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                cMaxRows = cPhrase.

            end. /* max-rows */

        end case. /* cKeyword */

    end. /* 2 to iKeywordPhraseCnt */



    create qry_ttQuery.
    assign
        qry_ttQuery.cQuery              = cQuery
        qry_ttQuery.cQueryTuning        = cQueryTuning
        qry_ttQuery.lBreak              = lBreak
        qry_ttQuery.cByExpList          = cByExpList
        qry_ttQuery.cByDescendList      = cByDescendList
        qry_ttQuery.lIndexedReposition  = lIndexedReposition
        qry_ttQuery.cMaxRows            = cMaxRows.



    iRecordPhraseCnt = num-entries( cRecordPhraseList, chr(1) ).

    do iRecordPhrase = 1 to iRecordPhraseCnt:

        cRecordPhrase = entry( iRecordPhrase, cRecordPhraseList, chr(1) ).

        run parseRecordPhrase(
            input iRecordPhrase,
            input cRecordPhrase ).

    end. /* iRecordPhrase */

end procedure. /* parseQuery */

procedure parseRecordPhrase private:

    define input param piRecordPhraseNum    as int no-undo.
    define input param pcRecordPhrase       as char no-undo.

    define buffer qry_ttRecordPhrase    for qry_ttRecordPhrase.
    define buffer qry_ttBuffer          for qry_ttBuffer.

    define var cJoin                as char no-undo.
    define var cBuffer              as char no-undo.
    define var cFields              as char no-undo.
    define var cExcept              as char no-undo.
    define var lLeft                as log no-undo.
    define var lOuterJoin           as log no-undo.
    define var cOf                  as char no-undo.
    define var cWhere               as char no-undo.
    define var cUseIndex            as char no-undo.
    define var cLock                as char no-undo.
    define var lNoPrefetch          as log no-undo.

    define var cBufferName          as char no-undo.
    define var cTableName           as char no-undo.
    define var cDbName              as char no-undo.

    define var cKeywordPhraseList   as char no-undo.
    define var iKeywordPhraseCnt    as int no-undo.
    define var cKeywordPhrase       as char no-undo.
    define var iKeywordPhrase       as int no-undo.
    define var cKeyword             as char no-undo.
    define var cPhrase              as char no-undo.

    define var hndl                 as handle no-undo.
    define var lOk                  as log no-undo.
    define var i                    as int no-undo.

    create widget-pool.

    assign
        cJoin           = ?
        cBuffer         = ?
        cFields         = ?
        cExcept         = ?
        lLeft           = no
        lOuterJoin      = no
        cOf             = ?
        cWhere          = ?
        cUseIndex       = ?
        cLock           = ?
        lNoPrefetch     = no

        cBufferName     = ?
        cTableName      = ?
        cDbName         = ?.



    assign
       cKeywordPhraseList   = pro_parseKeywordPhraseList(

            input pcRecordPhrase,
            input "each|first|last|left|fields|except|outer-join|of|where|use-index|exclusive-lock|exclusive|share-lock|share|no-lock|no-prefetch" )

       iKeywordPhraseCnt    = num-entries( cKeywordPhraseList, chr(1) ).

    if cKeywordPhraseList = "" then
        {slib/err_throw "'qry_unable_to_understand'" pcRecordPhrase}.



    assign
       cKeywordPhrase   = entry( 1, cKeywordPhraseList, chr(1) )
       cKeyword         = entry( 1, cKeywordPhrase, chr(2) )
       cPhrase          = entry( 2, cKeywordPhrase, chr(2) ).

    if cKeyword <> "each" and cKeyword <> "first" and cKeyword <> "last" then
        {slib/err_throw "'qry_unable_to_understand'" pcRecordPhrase}.

    if cPhrase = "" then
        {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

    assign
        cJoin      = cKeyword
        cBuffer    = cPhrase.



    case num-entries( cBuffer, "." ):

        when 1 then do:

            for each  qry_ttBuffer
                where qry_ttBuffer.cBufferName = cBuffer
                use-index BufferDb:

                if cBufferName <> ? then
                    {slib/err_throw "'qry_ambiguous_buffer_name'" cBuffer}.

                assign
                    cDbName     = qry_ttBuffer.cDbName
                    cTableName  = qry_ttBuffer.cTableName
                    cBufferName = qry_ttBuffer.cBufferName.

            end. /* each qry_ttBuffer */

            if cBufferName = ? then do:

                do i = 1 to num-dbs:

                    create buffer hndl for table ldbname(i) + "._file".

                    hndl:find-first( 'where _file-name = "' + cBuffer + '"', no-lock ).
                    lOk = hndl:avail.

                    delete object hndl.

                    if lOk then do:

                        if cBufferName <> ? then
                            {slib/err_throw "'qry_ambiguous_buffer_name'" cBuffer}.

                        assign
                            cDbName     = ldbname(i)
                            cTableName  = cBuffer
                            cBufferName = cTableName.

                    end. /* lOk */

                end. /* 1 to num-dbs */

                if cBufferName = ? then
                    {slib/err_throw "'qry_ambiguous_buffer_name'" cBuffer}.

            end. /* cBufferName = ? */

        end. /* when 1 */

        when 2 then do:

            assign
                cDbName     = entry( 1, cBuffer, "." )
                cTableName  = entry( 2, cBuffer, "." )
                cBufferName = cTableName.
            
            create buffer hndl for table cDbName + "._file".

            hndl:find-first( 'where _file-name = "' + cTableName + '"', no-lock ).
            lOk = hndl:avail.

            delete object hndl.

            if not lOk then
                {slib/err_throw "'qry_ambiguous_buffer_name'" cBuffer}.

        end. /* when 2 */

        otherwise
            {slib/err_throw "'qry_ambiguous_buffer_name'" cBuffer}.

    end case. /* num-entries( "." ) */

    if can-find(
        first qry_ttRecordPhrase
        where qry_ttRecordPhrase.cDbName        = cDbName
          and qry_ttRecordPhrase.cBufferName    = cBufferName ) then

        {slib/err_throw "'qry_unable_to_understand'" cBuffer}.



    do iKeywordPhrase = 2 to iKeywordPhraseCnt:

        assign
            cKeywordPhrase  = entry( iKeywordPhrase, cKeywordPhraseList, chr(1) )
            cKeyword        = entry( 1, cKeywordPhrase, chr(2) )
            cPhrase         = entry( 2, cKeywordPhrase, chr(2) ).

        case cKeyword:

            when "fields" then do:

                if iKeywordPhrase > 2 then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase = "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if not cPhrase matches "(*)" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                assign
                    cFields = pro_unparenthesis( cPhrase )
                    cFields = pro_parseWordList( cFields, yes, no ).

            end. /* fields */

            when "except" then do:

                if iKeywordPhrase > 2 then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase = "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if not cPhrase matches "(*)" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                assign
                    cExcept = pro_unparenthesis( cPhrase )
                    cExcept = pro_parseWordList( cExcept, yes, no ).

            end. /* except */

            when "left" then do:

                if lLeft <> no then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase <> "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if not ( iKeywordPhrase + 1 <= iKeywordPhraseCnt
                     and entry( 1, entry( iKeywordPhrase + 1, cKeywordPhraseList, chr(1) ), chr(2) ) = "outer-join" ) then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                lLeft = yes.

            end. /* left */

            when "outer-join" then do:

                if lOuterJoin <> no then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase <> "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                lOuterJoin = yes.

            end. /* outer-join */

            when "of" then do:

                if cOf <> ? then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase = "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                cOf = cPhrase.

            end. /* of */

            when "where" then do:

                if cWhere <> ? then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                cWhere = cPhrase.

            end. /* where */

            when "use-index" then do:

                if cUseIndex <> ? then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase = "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                cUseIndex = cPhrase.

            end. /* use-index */

            when "exclusive-lock" or
            when "exclusive" or
            when "share-lock" or 
            when "share" or
            when "no-lock" then do:

                if cLock <> ? then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase <> "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

            &if {&pro_xProversion} >= "10" &then
                if compare( cKeyword, "=", "SHARE", "raw" ) then
                cLock = "SHARE-LOCK".

                else
                if compare( cKeyword, "=", "share", "raw" ) then
                cLock = "share-lock".

                else
            &endif

                if cKeyword = "share" then
                cLock = "share-lock".

            &if {&pro_xProversion} >= "10" &then
                else
                if compare( cKeyword, "=", "EXCLUSIVE", "raw" ) then
                cLock = "EXCLUSIVE-LOCK".

                else
                if compare( cKeyword, "=", "exclusive", "raw" ) then
                cLock = "exclusive-lock".
            &endif

                else
                if cLock = "exclusive" then
                cLock = "exlcusive-lock".

                else
                cLock = cKeyword.

            end. /* exclusive-lock */

            when "no-prefetch" then do:

                if lNoPrefetch <> no then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                if cPhrase <> "" then
                    {slib/err_throw "'qry_unable_to_understand'" cKeyword}.

                lNoPrefetch = yes.

            end. /* no-prefetch */

        end case. /* cKeyword */

    end. /* 2 to iKeywordPhraseCnt */

    if cWhere = "" then
       cWhere = ?.



    create qry_ttRecordPhrase.
    assign
        qry_ttRecordPhrase.iRecordPhraseNum = piRecordPhraseNum
        qry_ttRecordPhrase.cRecordPhrase    =  cRecordPhrase
        qry_ttRecordPhrase.cDbName          = cDbName
        qry_ttRecordPhrase.cBufferName      = cBufferName
        qry_ttRecordPhrase.cFields          = cFields
        qry_ttRecordPhrase.cExcept          = cExcept
        qry_ttRecordPhrase.lLeft            = lLeft
        qry_ttRecordPhrase.lOuterJoin       = lOuterJoin
        qry_ttRecordPhrase.cUseIndex        = cUseIndex
        qry_ttRecordPhrase.cLock            = cLock
        qry_ttRecordPhrase.lNoPrefetch      = lNoPrefetch.

    if not can-find(
        first qry_ttBuffer
        where qry_ttBuffer.cDbName      = cDbName
          and qry_ttBuffer.cBufferName  = cBufferName ) then do:

        create qry_ttBuffer.
        assign
            qry_ttBuffer.cDbName        = cDbName
            qry_ttBuffer.cTableName     = cTableName
            qry_ttBuffer.cBufferName    = cBufferName.

    end. /* not can-find( qry_ttBuffer ) */



    /***
    if cOf <> ? then

    run parseOf(
        input   cOf,
        output  iWhereId ).

    if cWhere <> ? then

    run parseWhere(
        input   cWhere,
        output  iWhereId ).
    ***/

end procedure. /* parseRecordPhrase */

procedure parseOf private:



end procedure. /* parseOf */

procedure parseWhere private:

end procedure. /* parseWhere */

procedure parseParenthesis private:

end procedure. /* parseParenthesis */

procedure parsePredicate private:

end procedure. /* parsePredicate */



procedure refineParenthesis private:

end procedure. /* refineParenthesis */

procedure refineParethesisRecurr private:

end procedure. /* refineParenthesisRecurr */

procedure refineJoins private:

end procedure. /* refineJoins */

procedure refineLiterals private:

end procedure. /* refineLiterals */
