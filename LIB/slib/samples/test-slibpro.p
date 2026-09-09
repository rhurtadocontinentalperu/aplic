
/**
 * test-slibpro.p -
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

{slib/slibpro.i}

{slib/sliberr.i}



define var cQuery               as char no-undo.
define var cRecordPhraseList    as char no-undo.
define var cQueryTuning         as char no-undo.
define var lBreak               as log no-undo.
define var cByExpList           as char no-undo.
define var cByDescendList       as char no-undo.
define var lIndexedReposition   as log no-undo.
define var cMaxRows             as char no-undo.

define var cRecordPhrase        as char no-undo.
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
define var i                    as int no-undo.

define var cError               as char no-undo.
define var cErrorMsg            as char no-undo.
define var cStackTrace          as char no-undo.



{slib/err_try}:

    run pro_parseQueryPhrase(

        input   "for each  pt_mstr ~n" +
                "    where pt_part >= '1' ~n" +
                "      and pt_desc1 begins 't' ~n" +
                "    use-index pt_part ~n" +
                "    no-lock, ~n" +

                "    last  sod_det fields (sod_nbr sod_line sod_part) ~n" +
                "    where sod_part = pt_part ~n" +
                "    outer-join ~n" +
                "    exclusive ~n" +

                "    break ~n" +
                "    by pt_prod_line desc~n" +
                "    by pt_part ~n",

        output  cQuery,
        output  cRecordPhraseList,
        output  cQueryTuning,
        output  lBreak,
        output  cByExpList,
        output  cByDescendList,
        output  lIndexedReposition,
        output  cMaxRows ).

    display
        cQuery                                  label "query"               format "x(50)"
        cQueryTuning                            label "query-tuning"        format "x(50)"
        lBreak                                  label "break"
        replace( cByExpList, chr(1), "," )      label "by"                  format "x(50)"
        replace( cByDescendList, chr(1), "," )  label "by descend"          format "x(50)"
        lIndexedReposition                      label "indexed-reposition"
        cMaxRows                                label "max-rows"            format "x(50)"
    with 1 columns 1 down width 80.



    repeat i = 1 to num-entries( cRecordPhraseList, chr(1) ):

        cRecordPhrase = entry( i, cRecordPhraseList, chr(1) ).

        run pro_parseRecordPhrase(
            input   cRecordPhrase,
            output  cJoin,
            output  cBuffer,
            output  cFields,
            output  cExcept,
            output  lLeft,
            output  lOuterJoin,
            output  cOf,
            output  cWhere,
            output  cUseIndex,
            output  cLock,
            output  lNoPrefetch ).

        display
            cJoin                           label "join"            format "x(50)"
            cBuffer                         label "buffer"          format "x(50)"
            replace( cFields, chr(1), "," ) label "fields"          format "x(50)"
            replace( cExcept, chr(1), "," ) label "except"          format "x(50)"
            lLeft                           label "left"
            lOuterJoin                      label "outer-join"
            cOf                             label "of"              format "x(50)"
            cWhere                          label "where"           format "x(50)"
            cUseIndex                       label "use-index"       format "x(50)"
            cLock                           label "lock"            format "x(50)"
            lNoPrefetch                     label "no-prefetch"
        with 1 columns 1 down width 80.

    end. /* 1 to num-entries */

{slib/err_catch cError cErrorMsg cStackTrace}:

    message
        cErrorMsg
        skip(1)
        cStackTrace
    view-as alert-box.

{slib/err_end}.
