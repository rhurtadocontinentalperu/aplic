
/**
 * libqry.p -
 *
 * By Alon Blich
 */

{liberr.i "'libqry.err'"}

{libpro.i}



&global xWordSep " ,=<>()[]""'" /* the /+-* math operators signs are not word separators in 4gl. try display 1+1. */



/* for sequences i used theoritically limitless numbers decimal or int64 for later versions.
   although an integer and a cycle limit could have been used limitless numbers looked like the safer option. */

&if {&pro_xProversion} >= "10.1b" &then

    &global xSequence int64

&else

    &global xSequence dec

&endif



/* andCondition( ) and insertSafeValue( ) supported datatypes and operators */

&if     {&pro_xProversion} >= "10.1b" &then

    &global xSuppDataTypes 'character,logical,integer,int64,decimal,date,datetime,datetime-tz'

&elseif {&pro_xProversion} >= "10" &then

    &global xSuppDataTypes 'character,logical,integer,decimal,date,datetime,datetime-tz'

&else

    &global xSuppDataTypes 'character,logical,integer,decimal,date'

&endif

&global xSuppOperators '=,<,>,<=,>=,<>,begins,contains,between,in,matches,can-do'



/* handles are used as the queries, buffers and fields primary keys. primarily because if you've
   got the objects handle you've got everything else. name, related object handles etc.
   if unique id's were used that wouldn't be possible without using find, queries etc.
   handles are unique until the object is deleted. unique-id are also saved if they have been deleted. */

define temp-table ttQuery no-undo

    field hQuery                as handle
    field iQueryUniqueId        as int

    field lPreselect            as log
    field cQueryTuning          as char
    field cSortBy               as char

    /* cSortBy saves the complete phrase including by or break by keywords because it is somwhat
       more complicated then the basic phrase keyword, content pattern. the application allows 
       for break by even though dynamic queries do not support break by at the time this is 
       written in case support will be added at a later date. */

    field lIndexedReposition    as log
    field iMaxRows              as int
    field lPrepared             as log
    field lError                as log

    field iWherePersistId       as {&xSequence}
    field cWhereDynamic         as char
    field iWhereId              as {&xSequence}

    field cDefaultPlan          as char
    field cPlanProcName         as char
    field hPlanProcHandle       as handle

    index hQuery is primary unique
          hQuery.



define temp-table ttBuffer no-undo

    field hQuery                as handle
    field hBuffer               as handle
    field iBufferUniqueId       as int
    field cBufferName           as char
    field iBufferSeq            as int
    field cDbName               as char
    field lTempTable            as log

    field cLoop                 as char /* each, first, last */
    field cFields               as char /* saves the complete phrase including fields or except. */
    field lOuterJoin            as log
    field cUseIndex             as char
    field cLock                 as char
    field lNoPrefetch           as log

    field iWherePersistId       as {&xSequence}
    field cWhereDynamic         as char
    field iWhereId              as {&xSequence}

    field lUnknownBracket       as log
    field lFakeFirstLastPersist as log
    field lFakeFirstLastDynamic as log

    index QueryBuffer is primary unique
          hQuery
          hBuffer

    index QueryBufferSeq is unique
          hQuery
          iBufferSeq

    index QueryBufferName is unique
          hQuery
          cBufferName
          cDbName.



define temp-table ttWTree no-undo

    field hQuery            as handle
    field iParenthesisId    as {&xSequence}
    field iPredicateId      as {&xSequence}

    field iPredicateSeq     as {&xSequence}
    field cPredicateType    as char /* (exp)ression, (par)enthesis, literal, simple, simple2 */
    field cPredicateExp     as char /* string, buffer-field handle chr(1) delimiter list-item-pairs. the buffer-field can also have an extent number with a chr(2) delimiter. */

    field cParenthesisType  as char /* and, or, single */
    field lParenthesisNot   as log
    field iPredicateCnt     as int

    field lLiteralValue     as log

    field hSimpleField      as handle
    field iSimpleExtent     as int
    field cSimpleOperator   as char

    field hSimpleField2     as handle
    field iSimpleExtent2    as int
    field cSimpleOperator2  as char

    index iPredicateId is primary unique
          iPredicateId

    index WTree
          iParenthesisId
          iPredicateSeq

    index QueryPredicate
          hQuery
          iPredicateId.



define temp-table ttJoinField no-undo /* equality join fields */

    field hQuery        as handle
    field hBuffer       as handle
    field hField        as handle
    field cFieldName    as char
    field iFieldExtent  as int

    field iJoinId       as {&xSequence} /* the shared or grouping id */
    field iPredicateId  as {&xSequence}
    field iPredicateSeq as {&xSequence}
    field cDataType     as char

    index QueryField is primary unique
          hQuery
          hField
          iFieldExtent

    index JoinBuffer
          iJoinId
          hBuffer

    index BufferJoin
          hQuery
          hBuffer
          iPredicateSeq

    index QueryPredicate
          hQuery
          iPredicateId.



/* used in the parse where clause and scoped to the parse where cluse not the query */

define temp-table ttLiteral no-undo

    field iParenthesisId    as {&xSequence}
    field iPredicateId      as {&xSequence}

    field lLiteralValue     as log

    index WTree is primary
          iParenthesisId
          iPredicateId.



define temp-table ttParam no-undo

    field hQuery    as handle
    field iParamId  as {&xSequence}
    field cValue    as char

    index iParamId is primary unique
          iParamId

    index hQuery
          hQuery.

define var iPredicateIdSeq  as {&xSequence} no-undo.
define var iJoinIdSeq       as {&xSequence} no-undo.
define var iParamIdSeq      as {&xSequence} no-undo.



function createQuery        returns handle private  ( pcPrepare as char ) forward.
function isFakeFirstLast    returns log private     ( phBuffer  as handle, piWhereId as {&xSequence} ) forward.

function breakStatement     returns char private    ( pcStatement as char, pcPhraseList as char, pcExcludeList as char ) forward.
function trimSource         returns char private    ( pcSource as char ) forward.
function replaceNnn         returns char private    ( pcSource as char ) forward.

function insertSafeValue    returns char private    ( phQuery as handle, pcValue as char, pcDataType as char ) forward.
function insertValue        returns char private    ( phQuery as handle, pcValue as char, pcDataType as char ) forward.
function insertParam        returns char private    ( phQuery as handle, pcValue as char ) forward.
function unabbrType         returns char private    ( pcDataType as char ) forward.
function checkType          returns char private    ( pcValue as char, pcDataType as char ) forward.
function isBlank            returns log private     ( pcValue as char, pcDataType as char ) forward.



on "close" of this-procedure do:

    delete widget-pool "libqry" no-error.

    delete procedure this-procedure.

end. /* close of this-procedure */

run initializeProc.

procedure initializeProc private:

    create widget-pool "libqry".

    assign
        iPredicateIdSeq = 0
        iJoinIdSeq      = 0
        iParamIdSeq     = 0.

end procedure. /* initializeProc */



/* the reason for both having an external api and an internal version of these api (that other
   internal operations call) is mostly for adding a separate error handling behavior if a top
   level operation fails. mainly unpreparing and raising the query error flag. */

function qry_createQuery returns handle ( pcPrepare as char ):

    /* createQuery doesnt have the same query locking error handling because if it fails there is no query */

    return createQuery( pcPrepare ).

end function. /* qry_createQuery */

procedure qry_prepareQuery:

    define input param phQuery as handle no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run prepareQuery( buffer ttQuery ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_prepareQuery */

procedure qry_openQuery:

    define input param phQuery as handle no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run openQuery( buffer ttQuery ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_openQuery */

procedure qry_closeQuery:

    /* this procedure like most clean up operations does not throw exceptions. */

    define input param phQuery as handle no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run closeQuery( buffer ttQuery ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

    {err_end}.

end procedure. /* qry_closeQuery */

procedure qry_deleteQuery:

    /* this procedure like most clean up operations does not throw exceptions. */

    define input param phQuery as handle no-undo.

    run deleteQuery( phQuery ).

end procedure. /* qry_deleteQuery */



procedure qry_clearWhere:

    define input param phQuery as handle no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run clearWhere( buffer ttQuery ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_clearWhere */

procedure qry_setWhere:

    define input param phQuery as handle no-undo.
    define input param pcWhere as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run setWhere(
            buffer  ttQuery,
            input   ?,
            input   pcWhere ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_setWhere */

procedure qry_setBufferWhere:

    define input param phQuery  as handle no-undo.
    define input param pcBuffer as char no-undo.
    define input param pcWhere  as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run setWhere(
            buffer  ttQuery,
            input   pcBuffer,
            input   pcWhere ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_setBufferWhere */

procedure qry_andCondition:

    define input param phQuery      as handle no-undo.
    define input param pcField      as char no-undo.
    define input param pcOperator   as char no-undo.
    define input param pcValue      as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run andCondition(
            buffer  ttQuery,
            input   ?,
            input   pcField,
            input   pcOperator,
            input   pcValue,
            input   no ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_andCondition */

procedure qry_andCondition!:

    define input param phQuery      as handle no-undo.
    define input param pcField      as char no-undo.
    define input param pcOperator   as char no-undo.
    define input param pcValue      as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run andCondition(
            buffer  ttQuery,
            input   ?,
            input   pcField,
            input   pcOperator,
            input   pcValue,
            input   yes ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_andCondition! */

procedure qry_andBufferCondition:

    define input param phQuery      as handle no-undo.
    define input param pcBuffer     as char no-undo.
    define input param pcField      as char no-undo.
    define input param pcOperator   as char no-undo.
    define input param pcValue      as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run andCondition(
            buffer  ttQuery,
            input   pcBuffer,
            input   pcField,
            input   pcOperator,
            input   pcValue,
            input   no ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_andBufferCondition */

procedure qry_andBufferCondition!:

    define input param phQuery      as handle no-undo.
    define input param pcBuffer     as char no-undo.
    define input param pcField      as char no-undo.
    define input param pcOperator   as char no-undo.
    define input param pcValue      as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run andCondition(
            buffer  ttQuery,
            input   pcBuffer,
            input   pcField,
            input   pcOperator,
            input   pcValue,
            input   yes ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_andBufferCondition! */

procedure qry_andExpression:

    define input param phQuery      as handle no-undo.
    define input param pcExpression as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run andExpression(
            buffer  ttQuery,
            input   ?,
            input   pcExpression ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_andExpression */

procedure qry_andBufferExpression:

    define input param phQuery      as handle no-undo.
    define input param pcBuffer     as char no-undo.
    define input param pcExpression as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        run andExpression(
            buffer  ttQuery,
            input   pcBuffer,
            input   pcExpression ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_andBufferExpression */

function qry_insertSafeValue returns char ( phQuery as handle, pcValue as char, pcDataType as char ):

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        return insertSafeValue( ttQuery.hQuery, pcValue, pcDataType ).

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end function. /* qry_insertSafeValue */

/* for the library internal use not for users external use also not listed in the library prototype does not require error handling */

function qry_getParam returns char ( piParamId as {&xSequence} ):

    define buffer ttParam for ttParam.

    find first ttParam
         where ttParam.iParamId = piParamId
         use-index iParamId
         no-error.

    if avail ttParam then
         return ttParam.cValue.
    else return ?.

end function. /* qry_getParam */



/* qry_setSortBy( ) and qry_setMaxRows( ) only assign a value and an internal version isn't required */

procedure qry_setSortBy:

    define input param phQuery  as handle no-undo.
    define input param pcSortBy as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        ttQuery.cSortBy = pcSortBy.

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_setSortBy */

procedure qry_setMaxRows:

    define input param phQuery      as handle no-undo.
    define input param pcMaxRows    as char no-undo.

    define buffer ttQuery for ttQuery.

    run getQuery( phQuery, buffer ttQuery ).

    if ttQuery.lError then
        {err_throw "'qry_query_contains_error'"}.

    {err_try}:

        ttQuery.iMaxRows = int( pcMaxRows ) {err_no-error}.

    {err_catch}:

        run protectQuery( buffer ttQuery ).

        {err_throw last}.

    {err_end}.

end procedure. /* qry_setMaxRows */



function createQuery returns handle private ( pcPrepare as char ):

    define var hQuery as handle no-undo.

    {err_try}:

        create query hQuery in widget-pool "libqry".

        if pcPrepare = "" 
        or pcPrepare = ? then
            {err_throw "'qry_blank_create_query'"}.

        pcPrepare = trimSource( pcPrepare ).

        run parsePrepareString(
            input hQuery,
            input pcPrepare ).

        {err_return hQuery}.

    {err_catch}:

        run deleteQuery( hQuery ).

        {err_throw last}.

    {err_end}.

end function. /* createQuery */

procedure prepareQuery private:

    define param buffer pbQuery for ttQuery.



end procedure. /* prepareQuery */

procedure openQuery private:

    define param buffer pbQuery for ttQuery.

end procedure. /* openQuery */

procedure closeQuery private:

    define param buffer pbQuery for ttQuery.

end procedure. /* closeQuery */

procedure deleteQuery private:

    /* this procedure like most clean up operations does not throw exceptions. */

    define input param phQuery as handle no-undo.

    define buffer ttQuery       for ttQuery.
    define buffer ttBuffer      for ttBuffer.
    define buffer ttWTree       for ttWTree.
    define buffer ttJoinField   for ttJoinField.
    define buffer ttParam       for ttParam.

    {err_try}:

        /* deleteQuery can also deletes queries that haven't been successfully created that may 
           not even have a query record. in this case this block will be aborted but the 
           proceeding delete object will be executed. */

        run getQuery( phQuery, buffer ttQuery ).

        for each  ttBuffer
            where ttBuffer.hQuery = ttQuery.hQuery
            use-index QueryBufferSeq:

            delete ttBuffer.

        end. /* for each */

        for each  ttWTree
            where ttWTree.hQuery = ttQuery.hQuery
            use-index QueryPredicate:

            delete ttWTree.

        end. /* for each */

        for each  ttJoinField
            where ttJoinField.hQuery = ttQuery.hQuery
            use-index QueryPredicate:

            delete ttJoinField.

        end. /* for each */

        for each  ttParam
            where ttParam.hQuery = ttQuery.hQuery
            use-index hQuery:

            delete ttParam.

        end. /* for each */

        delete ttQuery.

    {err_finally}:

        if valid-handle( phQuery ) then
           delete object phQuery no-error.

    {err_end}.

end procedure. /* deleteQuery */

procedure protectQuery private:

    define param buffer pbQuery for ttQuery.

    define buffer ttBuffer for ttBuffer.

    for each  ttBuffer
        where ttBuffer.hQuery = ttQuery.hQuery
        use-index QueryBufferSeq:

        run deleteParenthesis( ttBuffer.iWhereId ).

        ttBuffer.iWhereId = ?.

    end. /* for each */

    run deleteParenthesis( pbQuery.iWhereId ).

    for each  ttParam
        where ttParam.hQuery = pbQuery.hQuery
        use-index hQuery:

        delete ttParam.

    end. /* for each */

    assign
        pbQuery.lPrepared   = no
        pbQuery.lError      = yes

        pbQuery.iWhereId    = ?.



    find first ttBuffer
         where ttBuffer.hQuery = ttQuery.hQuery
         use-index QueryBufferSeq
         no-error.

    pbQuery.hQuery:set-buffers( ttBuffer.hBuffer ).

    repeat:

        find next ttBuffer
            where ttBuffer.hQuery = ttQuery.hQuery
            use-index QueryBufferSeq
            no-error.

        if not avail ttBuffer then leave.

        pbQuery.hQuery:add-buffer( ttBuffer.hBuffer ).

    end. /* repeat */

end procedure. /* protectQuery */

procedure clearWhere private:

    define param buffer pbQuery for ttQuery.

    define buffer ttBuffer for ttBuffer.

    for each  ttBuffer
        where ttBuffer.hQuery = ttQuery.hQuery
        use-index QueryBufferSeq:

        run deleteParenthesis( ttBuffer.iWhereId ).

        assign
            ttBuffer.cWhereDynamic          = ""
            ttBuffer.iWhereId               = ?

            ttBuffer.lFakeFirstLastDynamic  = no.

    end. /* for each */

    run deleteParenthesis( pbQuery.iWhereId ).

    for each  ttParam
        where ttParam.hQuery = pbQuery.hQuery
        use-index hQuery:

        delete ttParam.

    end. /* for each */

    assign
        pbQuery.lPrepared       = no
        pbQuery.lError          = no

        pbQuery.cWhereDynamic   = ""
        pbQuery.iWhereId        = ?.



    find first ttBuffer
         where ttBuffer.hQuery = ttQuery.hQuery
         use-index QueryBufferSeq
         no-error. /* queries that have been successfully created have at least one buffer */

    pbQuery.hQuery:set-buffers( ttBuffer.hBuffer ).

    repeat:

        find next ttBuffer
            where ttBuffer.hQuery = ttQuery.hQuery
            use-index QueryBufferSeq
            no-error.

        if not avail ttBuffer then leave.

        pbQuery.hQuery:add-buffer( ttBuffer.hBuffer ).

    end. /* repeat */

end procedure. /* clearWhere */



procedure parseQuery private:

    define input param phQuery      as handle no-undo.
    define input param pcStatement  as char no-undo.

    define buffer ttQuery for ttQuery.
    define buffer ttWTree for ttWTree.

    define var cPhrase              as char no-undo.
    define var cPhraseContent       as char no-undo.

    define var lPreselect           as log no-undo.
    define var cRecordList          as char no-undo.
    define var cQueryTuning         as char no-undo.
    define var cSortBy              as char no-undo.
    define var lIndexedReposition   as log no-undo.
    define var iMaxRows             as int no-undo.

    define var str                  as char no-undo.
    define var i                    as int no-undo.
    define var j                    as int no-undo.

    str = entry( 1, pcStatement, " " ).

    if str = "preselect" then
         lPreselect = yes.

    else
    if str = "for" then
         lPreselect = no.

    else {err_throw "'qry_for_preselect_expected'"}.

    substr( pcStatement, 1, length( str ) + 1 ) = "".

    if pcStatement = "" then
         {err_throw "'qry_record_phrase_not_found'"}.



    assign
        pcStatement         = breakStatement(

            pcStatement,
            "query-tuning|break|by|indexed-reposition|max-rows",
            "|by|by||" )

        cRecordList         = ?
        cQueryTuning        = ?
        cSortBy             = ?
        lIndexedReposition  = ?
        iMaxRows            = ?

    j = num-entries( pcStatement, chr(1) ). do i = 1 to j:

        assign
            str             = entry( i, pcStatement, chr(1) )

            cPhrase         = entry( 1, str, chr(2) )
            cPhraseContent  = entry( 2, str, chr(2) ).

        case cPhrase:

            when "" then

                cRecordList = cPhraseContent.

            when "query-tuning" then do:

                if cQueryTuning <> ? then
                    {err_throw "'qry_multiple_query_tuning'"}.

                if cPhraseContent = "" then
                    {err_throw "'qry_blank_query_tuning'"}.

                if not ( cPhraseContent begins "(" and substr( cPhraseContent, length( cPhraseContent ), 1 ) = ")" ) then
                    {err_throw "'qry_parenthesized_argument_expected'"}.

                cQueryTuning = cPhraseContent.

            end. /* query-tuning */

            when "break" or when "by" then do:

                if cSortBy <> ? then
                    {err_throw "'qry_multiple_sort_phrase'"}.

                if cPhraseContent = "" then
                    {err_throw "'qry_blank_sort_phrase'"}.

                cSortBy = cPhrase + " " + cPhraseContent.

            end. /* break or by */

            when "indexed-reposition" then do:

                if lIndexedReposition <> ? then
                    {err_throw "'qry_multiple_indexed_reposition'"}.

                if cPhraseContent <> "" then
                    {err_throw "'qry_unable_to_understand'" cPhrase}.

                lIndexedReposition = yes.

            end. /* indexed-reposition */

            when "max-rows" then do:

                if iMaxRows <> ? then
                    {err_throw "'qry_multiple_max_rows'"}.

                iMaxRows = int( cPhraseContent ).

                if iMaxRows = ? then
                    {err_throw "'qry_invalid_max_rows'"}.

            end. /* max-rows */

        end case. /* cPhrase */

    end. /* 1 to num-entries */

    if cRecordList = ? then
        {err_throw "'qry_record_phrase_not_found'"}.



    create ttQuery. 
    assign
        ttQuery.hQuery              = phQuery
        ttQuery.iQueryUniqueId      = phQuery:unique-id

        ttQuery.lPreselect          = lPreselect
        ttQuery.cQueryTuning        = cQueryTuning
        ttQuery.cSortBy             = cSortBy
        ttQuery.lIndexedReposition  = lIndexedReposition
        ttQuery.iMaxRows            = iMaxRows
        ttQuery.lPrepared           = no

        ttQuery.iWherePersistId     = ?
        ttQuery.cWhereDynamic       = ""
        ttQuery.iWhereId            = ?

        ttQuery.cDefaultPlan        = ?
        ttQuery.cPlanProcName       = ?
        ttQuery.hPlanProcHandle     = ?.

    run parseRecordList(
        input   phQuery,
        input   cRecordList,
        output  ttQuery.iWherePersistId ).

end procedure. /* parseQuery */

procedure parseRecordList private:

    define input    param phQuery       as handle no-undo.
    define input    param pcRecordList  as char no-undo.
    define output   param piWhereId     as {&xSequence} no-undo.

    define buffer ttQuery   for ttQuery.
    define buffer ttBuffer  for ttBuffer.
    define buffer ttWTree   for ttWTree.

    define var cRecord          as char no-undo.
    define var iRecord          as int no-undo.
    define var iRecordNum       as int no-undo.

    define var cPhrase          as char no-undo.
    define var iPhrase          as int no-undo.
    define var iPhraseNum       as int no-undo.
    define var cPhraseContent   as char no-undo.

    define var cSub             as char no-undo.
    define var iSub             as int no-undo.
    define var iSubNum          as int no-undo.
    define var cSubContent      as char no-undo.

    define var cLoop            as char no-undo.
    define var hBuffer          as handle no-undo.
    define var cFields          as char no-undo.
    define var cOf              as char no-undo.
    define var iOfId            as {&xSequence} no-undo.
    define var cWhere           as char no-undo.
    define var iWhereId         as {&xSequence} no-undo.
    define var lOuterJoin       as log no-undo.
    define var cUseIndex        as char no-undo.
    define var cLock            as char no-undo.
    define var lNoPrefetch      as log no-undo.
    define var lFakeFirstLast   as log no-undo.

    define var str              as char no-undo.

    assign
        pcRecordList    = breakStatement(

            pcRecordList,
            "left|outer-join|of|where|use-index|exclusive-lock|exclusive|share-lock|share|no-lock|no-prefetch|,",
            "outer-join|||||||||||" )

        piWhereId       = ?

    iRecordNum = num-entries( pcRecordList, chr(3) ). do iRecord = 1 to iRecordNum:

        assign
            cRecord     = entry( iRecord, pcRecordList, chr(3) )

            cLoop       = ?
            hBuffer     = ?
            cFields     = ?
            cOf         = ?
            iOfId       = ?
            cWhere      = ?
            iWhereId    = ?
            lOuterJoin  = ?
            cUseIndex   = ?
            cLock       = ?
            lNoPrefetch = ?.

        if cRecord = "" then 
            {err_throw "'qry_blank_record_phrase'"}.

        cLoop = entry( 1, cRecord, " " ).

        if  cLoop <> "each"
        and cLoop <> "first"
        and cLoop <> "last" then
            {err_throw "'qry_each_first_last_expected'"}.

        substr( cRecord, 1, length( cLoop ) + 1 ) = "".

        if cRecord = "" then
            {err_throw  "'buffer_handle_expected'"}.



        iPhraseNum = num-entries( cRecord, chr(1) ). do iPhrase = 1 to iPhraseNum:

            assign
                str             = entry( iPhrase, cRecord, chr(1) )

                cPhrase         = entry( 1, str, chr(2) )
                cPhraseContent  = entry( 2, str, chr(2) ).

            case cPhrase:

                when "" then do:

                    assign
                        cPhrase = breakStatement(

                            cPhrase,
                            "fields|except",
                            "|" )

                    iSubNum = num-entries( cPhrase, chr(1) ). do iSub = 1 to iSubNum:

                        assign
                            str         = entry( iSub, cPhrase, chr(1) )

                            cSub        = entry( 1, str, chr(2) )
                            cSubContent = entry( 2, str, chr(2) ).

                        case cSub:

                            when "" then do:

                                hBuffer = widget-handle( entry( 1, cSubContent, chr(1) ) ) no-error.

                                if hBuffer = ? then
                                    {err_throw "'qry_invalid_buffer_ref'"}.

                                if not ( valid-handle( hBuffer ) and hBuffer:type = "buffer" ) then
                                    {err_throw "'qry_invalid_buffer_handle'"}.

                                if can-find( first ttBuffer where ttBuffer.hQuery = phQuery and ttBuffer.hBuffer = hBuffer use-index QueryBuffer ) then
                                    {err_throw "'qry_buffer_multiple_use'" hBuffer:name}.

                            end. /* "" */

                            when "fields" or when "except" then do:

                                if cFields <> "" then
                                    {err_throw "'qry_multiple_fields_except'"}.

                                if not ( cSubContent begins "(" and substr( cSubContent, length( cSubContent ), 1 ) = ")" ) then
                                    {err_throw "'qry_parenthesized_argument_expected'" cSub}.

                                cFields = cSub + " " + cSubContent.

                            end. /* fields or except */

                        end case. /* cSub */

                    end. /* 1 to iSubNum */

                    if hBuffer = ? then
                        {err_throw "'qry_buffer_handle_expected'"}.

                end. /* "" */



                when "of" then do:

                    if cOf <> ? then
                        {err_throw "'qry_multiple_of_phrase'"}.

                    if cPhraseContent = "" then
                        {err_throw "'qry_blank_of_phrase'"}.

                    cOf = cPhraseContent.

                end. /* of */                

                when "where" then do:

                    if cWhere <> ? then
                        {err_throw "'qry_multiple_where_clause'"}.

                    cWhere = cPhraseContent.

                end. /* where */

                when "left" then do:

                    if cPhraseContent <> "outer-join" then
                        {err_throw "'qry_unable_to_understand'" cPhrase}.

                    if lOuterJoin <> ? then
                        {err_throw "'qry_multiple_outer_join'"}.

                    lOuterJoin = yes.

                end. /* left */

                when "outer-join" then do:

                    if lOuterJoin <> ? then
                        {err_throw "'qry_multiple_outer_join'"}.

                    lOuterJoin = yes.

                end. /* outer-join */

                when "use-index" then do:

                    if cUseIndex <> ? then
                        {err_throw "'qry_multiple_use_index'"}.

                    if cPhraseContent = "" then
                        {err_throw "'qry_blank_use_index'"}.

                    cUseIndex = cPhraseContent.

                end. /* use-index */

                   when "exclusive-lock" 
                or when "exclusive"
                or when "share-lock"
                or when "share"
                or when "no-lock" then do:

                    if cLock <> ? then
                        {err_throw "'qry_multiple_lock_phrase'"}.

                    if cPhraseContent <> "" then
                        {err_throw "'qry_unable_to_understand'" cPhrase}.

                    case cPhrase:

                        when "exclusive"    then cPhrase = "exclusive-lock".
                        when "share"        then cPhrase = "share-lock".

                    end case. /* cPhrase */

                    cLock = cPhrase.

                end. /* lock phrase */

                when "no-prefetch" then do:

                    if lNoPrefetch <> ? then
                        {err_throw "'qry_multiple_no_prefetch'"}.

                    if cPhraseContent <> "" then
                        {err_throw "'qry_unable_to_understand'" cPhrase}.

                    lNoPrefetch = yes.

                end. /* no-prefetch */

            end case. /* cPhrase */

        end. /* 1 to iPhraseNum */

        if hBuffer = ? then
            {err_throw "'qry_buffer_handle_expected'"}.



        if cOf <> ? then

        run parseOfPhrase(
            input   phQuery,
            input   hBuffer,
            input   cOf,
            output  iOfId ).

        if cWhere <> ? and cWhere <> "" then /* blank where clause is perfectly valid but there no need to parse it */

        run parseWhere(
            input   phQuery,
            input   cWhere,
            output  iWhereId ).

        if iOfId <> ? then

        run joinParenthesisByAnd(
            input-output    iWhereId,
            input           iOfId ).

        if iWhereId <> ? then do:

            lFakeFirstLast = no.

            if ( cLoop = "first"
              or cLoop = "last" ) then

                lFakeFirstLast = isFakeFirstLast( hBuffer, iWhereId ).

            if not ( lOuterJoin
            
                  or ( cLoop = "first" 
                    or cLoop = "last" ) 
                   and lFakeFirstLast = no ) then do:

                run joinParenthesisByAnd(
                    input-output    piWhereId,
                    input            iWhereId ).

                iWhereId = ?.

            end. /* not lOuterJoin */

        end. /* iWhereId <> ? */



        create ttBuffer.
        assign
            ttBuffer.hQuery                 = phQuery
            ttBuffer.hBuffer                = hBuffer
            ttBuffer.iBufferUniqueId        = hBuffer:unique-id
            ttBuffer.cBufferName            = hBuffer:name
            ttBuffer.iBufferSeq             = iRecord
            ttBuffer.cDbName                = hBuffer:dbname
            ttBuffer.lTempTable             = hBuffer:table-handle <> ?

            ttBuffer.cLoop                  = cLoop
            ttBuffer.cFields                = cFields
            ttBuffer.lOuterJoin             = lOuterJoin
            ttBuffer.cUseIndex              = cUseIndex
            ttBuffer.cLock                  = cLock
            ttBuffer.lNoPrefetch            = lNoPrefetch

            ttBuffer.iWherePersistId        = iWhereId
            ttBuffer.cWhereDynamic          = ""
            ttBuffer.iWhereId               = ?

            ttBuffer.lUnknownBracket        = no
            ttBuffer.lFakeFirstLastPersist  = lFakeFirstLast
            ttBuffer.lFakeFirstLastDynamic  = no.

    end. /* 1 to iRecordNum */

end procedure. /* parseRecordList */

procedure parseOf private:

    define input    param phQuery           as handle no-undo.
    define input    param phBuffer          as handle no-undo.
    define input    param pcOf              as char no-undo.
    define output   param piOfParenthesisId as {&xSequence} no-undo.

    define buffer ttBuffer      for ttBuffer.
    define buffer ttWTree       for ttWTree.
    define buffer bParenthesis  for ttWTree.

    define var hOfBuffer    as handle no-undo.

    define var hIndexBuffer as handle no-undo.
    define var cIndexInfo   as char no-undo.
    define var iIndexNum    as int no-undo.

    define var cFieldName   as char no-undo.
    define var hFieldOf     as handle no-undo.
    define var hField       as handle no-undo.

    define var i            as int no-undo.
    define var j            as int no-undo. 



    case num-entries( pcOf, "." ):

        when 1 then

        find ttBuffer 
             where ttBuffer.hQuery      = phQuery
               and ttBuffer.cBufferName = pcOf
             use-index QueryBufferName
             no-error.

        when 2 then

        find ttBuffer 
             where ttBuffer.hQuery      = phQuery
               and ttBuffer.cBufferName = entry( 2, pcOf, "." )
               and ttBuffer.cDbName     = entry( 1, pcOf, "." )
             use-index QueryBufferName
             no-error.

        otherwise
        {err_throw "'qry_invalid_buffer_name'" pcOf}.

    end case. /* num-entries */

    if not avail ttBuffer then
        {err_throw "'qry_unknown_buffer'" pcOf}.



    assign
        piOfParenthesisId   = ?

        hOfBuffer           = ttBuffer.hBuffer

    hIndexBuffer = phBuffer.

    repeat:

        iIndexNum = 1.

        repeat:

            cIndexInfo = hIndexBuffer:index-information( iIndexNum ) no-error. if cIndexInfo = ? then leave.

            if entry( 3, cIndexInfo ) = "1" then

            _Join:

            do:

                j = num-entries( cIndexInfo ).

                do i = 5 to j by 2:

                    assign
                        cFieldName  = entry( i, cIndexInfo )
                        hFieldOf    = hOfBuffer :buffer-field( cFieldName )
                        hField      = phBuffer  :buffer-field( cFieldName ) no-error.

                    if not ( valid-handle( hFieldOf )
                         and valid-handle( hField )
                         and hField:data-type = hFieldOf:data-type ) then leave _Join.

                end. /* 5 to j */



                if piOfParenthesisId <> ? then
                    {err_throw "'qry_multiple_matching_indexes_for_of_phrase'" phBuffer:name hOfBuffer:name}.

                assign
                    iPredicateIdSeq                 = iPredicateIdSeq + 1

                    piOfParenthesisId               = iPredicateIdSeq.

                create bParenthesis.
                assign
                    bParenthesis.hQuery             = phQuery
                    bParenthesis.iParenthesisId     = ?
                    bParenthesis.iPredicateId       = iPredicateIdSeq

                    bParenthesis.iPredicateSeq      = bParenthesis.iPredicateId
                    bParenthesis.cPredicateType     = "par"
                    bParenthesis.cPredicateExp      = ?

                    bParenthesis.cParenthesisType   = "and"
                    bParenthesis.lParenthesisNot    = no
                    bParenthesis.iPredicateCnt      = 0

                    bParenthesis.lLiteralValue      = ?

                    bParenthesis.hSimpleField       = ?
                    bParenthesis.iSimpleExtent      = ?
                    bParenthesis.cSimpleOperator    = ?

                    bParenthesis.hSimpleField2      = ?
                    bParenthesis.iSimpleExtent2     = ?
                    bParenthesis.cSimpleOperator2   = ?.

                do i = 5 to j by 2:

                    assign
                        cFieldName  = entry( i, cIndexInfo )
                        hFieldOf    = hOfBuffer :buffer-field( cFieldName )
                        hField      = phBuffer  :buffer-field( cFieldName ) no-error.

                    assign
                        bParenthesis.iPredicateCnt  = bParenthesis.iPredicateCnt + 1

                        iPredicateIdSeq             = iPredicateIdSeq + 1.

                    create ttWTree.
                    assign
                        ttWTree.hQuery              = phQuery
                        ttWTree.iParenthesisId      = bParenthesis.iPredicateId
                        ttWTree.iPredicateId        = iPredicateIdSeq

                        ttWTree.iPredicateSeq       = ttWTree.iPredicateId
                        ttWTree.cPredicateType      = "simple2"
                        ttWTree.cPredicateExp       = ?

                        ttWTree.cParenthesisType    = ?
                        ttWTree.lParenthesisNot     = ?
                        ttWTree.iPredicateCnt       = ?

                        ttWTree.lLiteralValue       = ?

                        ttWTree.hSimpleField        = hField
                        ttWTree.iSimpleExtent       = ?
                        ttWTree.cSimpleOperator     = "="

                        ttWTree.hSimpleField2       = hFieldOf
                        ttWTree.iSimpleExtent2      = ?
                        ttWTree.cSimpleOperator2    = "=".

                end. /* 5 to j */

            end. /* _Join */

            iIndexNum = iIndexNum + 1.

        end. /* repeat */

        if hIndexBuffer = phBuffer then
           hIndexBuffer = hOfBuffer.

        else leave.

    end. /* repeat */

    if piOfParenthesisId = ? then
        {err_throw "'qry_matching_indexes_not_found_for_of_phrase'" phBuffer:name hOfBuffer:name}.

end procedure. /* parseOfPharse */

procedure parseWhere private:

    define input    param phQuery   as handle no-undo.
    define input    param pcWhere   as char no-undo.
    define output   param piWhereId as {&xSequence} no-undo.

    empty temp-table ttLiteral.

    run parseParenthesis( 
        input   phQuery,
        input   ?,
        input   no,
        input   pcWhere,
        output  piWhereId ).

    run refineLiterals(
        input phQuery, 
        input piWhereId ).

    run refineParenthesis( 
        input piWhereId ).

end procedure. /* parseWhere */

procedure parseParenthesis private:

    define input    param phQuery           as handle no-undo.
    define input    param piParentId        as {&xSequence} no-undo.
    define input    param plParenthesisNot  as log no-undo.
    define input    param pcParenthesis     as char no-undo.
    define output   param piParenthesisId   as {&xSequence} no-undo.

    define buffer ttWTree       for ttWTree.
    define buffer bParenthesis  for ttWTree.

    define var cParenthesisType     as char no-undo.
    define var iPredicateCnt        as int no-undo.

    define var cOperator            as char no-undo.
    define var iOperatorStart       as int no-undo.
    define var iOperatorEnd         as int no-undo.

    define var cPrev                as char no-undo.
    define var iPrevStart           as int no-undo.
    define var iPrevEnd             as int no-undo.

    define var iParenthesisIdBaseOr as {&xSequence} no-undo.
    define var iParenthesisIdCurr   as {&xSequence} no-undo.
    define var lParenthesisSub      as log no-undo.

    define var cParenthesisContent  as char no-undo.
    define var iParenthesisStart    as int no-undo.
    define var iParenthesisEnd      as int no-undo.
    define var lParenthesisNot      as log no-undo.

    define var iOpenBracket         as int no-undo.
    define var iOpenExtent          as int no-undo.
    define var lWordSep             as log no-undo.

    define var iLen                 as int no-undo.
    define var iPos                 as int no-undo.
    define var ch                   as char no-undo.

    define var str                  as char no-undo.
    define var i                    as int no-undo.
    define var j                    as int no-undo.

    assign
        pcParenthesis           = trim( pcParenthesis )

        cPrev                   = ?
        iPrevStart              = 1
        iPrevEnd                = iPrevStart

        iParenthesisIdBaseOr    = ?
        iParenthesisIdCurr      = ?
        lParenthesisSub         = no

        iOpenBracket            = 0
        iOpenExtent             = 0
        lWordSep                = yes

        iLen                    = length( pcParenthesis )
        iPos                    = 1.

    do for bParenthesis:

        repeat while iPos <= iLen:

            assign
                cOperator           = ?
                iOperatorStart      = iLen + 1
                iOperatorEnd        = iOperatorStart

                cParenthesisContent = ""
                iParenthesisStart   = ?
                iParenthesisEnd     = ?
                lParenthesisNot     = no.

            repeat while iPos <= iLen:

                ch = substr( pcParenthesis, iPos, 1 ).

                if ch = '"' or ch = "'" then do:

                    define var cQuote as char no-undo.

                    assign
                        lWordSep    = yes
                        cQuote      = ch
                        iPos        = iPos + 1.

                    repeat while iPos <= iLen:

                        ch = substr( pcParenthesis, iPos, 1 ).

                        if ch = cQuote then do:

                            if substr( pcParenthesis, iPos + 1, 1 ) = cQuote then

                                iPos = iPos + 2.

                            else do:

                                iPos = iPos + 1.

                                leave.

                            end. /* else */

                        end. /* ch = cQuote */

                        else
                        if ch = "~~" or ch = "~\" and opsys = "unix" then do:

                            ch = substr( pcParenthesis, iPos + 1, 1 ).

                            if ch = '"' or ch = "'" or ch = "~~" or ch = "~\" then 
                                 iPos = iPos + 2.
                            else iPos = iPos + 1.

                        end. /* "~" */

                        else
                        iPos = iPos + 1.

                    end. /* repeat */

                    if iPos > iLen then
                        {err_throw "'qry_unmatched_quote'"}.

                end. /* '"' */



                else
                if ch = "~~" or ch = "~\" and opsys = "unix" then do:

                    ch = substr( pcParenthesis, iPos + 1, 1 ).

                    if ch = '"' or ch = "'" then
                    assign 
                        lWordSep    = yes
                        iPos        = iPos + 2.

                    if ch = "~~" or ch = "~\" then 
                    assign 
                        lWordSep    = no
                        iPos        = iPos + 2.

                    else
                    assign
                        iPos        = iPos + 1.

                end. /* "~" */



                else
                if  ch >= "a" and ch <= "z" and lWordSep

                and iOpenBracket = 0 and iOpenExtent = 0 then do:

                    assign
                        i           = iPos

                        lWordSep    = no
                        iPos        = iPos + 1.

                    repeat while iPos <= iLen:

                        ch = substr( pcParenthesis, iPos, 1 ).

                        if not ( ch >= "a" and ch <= "z"
                              or ch >= "0" and ch <= "9"
                              or ch = "_" or ch = "-" or ch = "." ) then

                            leave.

                        iPos = iPos + 1.

                    end. /* repeat */

                    str = substr( pcParenthesis, i, iPos - i ).

                    if str = "and" or str = "or" then do:

                        assign
                            cOperator       = str
                            iOperatorStart  = i
                            iOperatorEnd    = iPos.

                        leave.

                    end. /* and/or */

                end. /* "a".."z" */



                else do:

                    if ch = "(" or ch = ")"
                    or ch = "[" or ch = "]" then do:

                        case ch:

                            when "(" then do:

                                iOpenBracket = iOpenBracket + 1.

                                if iParenthesisStart = ? and iOpenBracket = 1 then do:

                                    assign
                                        iParenthesisStart = iPos

                                        str = trim( substr( pcParenthesis,
                                            iPrevEnd, iParenthesisStart - iPrevEnd ) )

                                    j = num-entries( str, " " ). do i = 1 to j:

                                        if entry( i, str, " " ) = "NOT" then
                                            lParenthesisNot = not lParenthesisNot.

                                        else do:

                                            lParenthesisNot = ?.

                                            leave.

                                        end. /* else */

                                    end. /* 1 to num-entries */

                                end. /* iParenthesisStart = ? */

                            end. /* "(" */

                            when ")" then do:

                                if iParenthesisEnd = ? and iOpenBracket = 1 then do:

                                    assign
                                        iParenthesisEnd     = iPos
                                    
                                        cParenthesisContent = substr( pcParenthesis,
                                            iParenthesisStart + 1, 
                                            iParenthesisEnd - iParenthesisStart - 1 ).

                                end. /* iParenthesisEnd = ? */

                                iOpenBracket = iOpenBracket - 1.

                            end. /* ")" */

                            when "[" then iOpenExtent = iOpenExtent + 1.
                            when "]" then iOpenExtent = iOpenExtent - 1.

                        end case. /* ch */

                        if iOpenBracket < 0 then {err_throw "'qry_closing_bracket_not_expected'"}.
                        if iOpenExtent  < 0 then {err_throw "'qry_closing_square_bracket_not_expected'"}.

                        assign
                            lWordSep    = yes
                            iPos        = iPos + 1.

                    end. /* "(", ")", "[", "]" */

                    else do:

                        assign
                            lWordSep    = ( index( {&xWordSep}, ch ) > 0 )
                            iPos        = iPos + 1.

                    end. /* else */

                end. /* else */

            end. /* repeat */



            if cPrev = ? and cOperator = ? then do: /* first and last predicate */

                assign
                    iPredicateIdSeq         = iPredicateIdSeq + 1
                    iParenthesisIdCurr      = iPredicateIdSeq
                    lParenthesisSub         = no

                    piParenthesisId         = iParenthesisIdCurr
                    cParenthesisType        = "single"
                    iPredicateCnt           = 0.

            end. /* cPrev = ? and cOperator = ? */

            else
            if cPrev = ? and cOperator <> ? then do: /* first predicate but not last */

                assign
                    iPredicateIdSeq         = iPredicateIdSeq + 1
                    iParenthesisIdCurr      = iPredicateIdSeq
                    lParenthesisSub         = no

                    piParenthesisId         = iParenthesisIdCurr
                    cParenthesisType        = cOperator
                    iPredicateCnt           = 0.

                if cOperator = "or" then
                    iParenthesisIdBaseOr    = iParenthesisIdCurr.

            end. /* cPrev = ? and cOperator <> ? */

            else
            if cPrev = "or" and cOperator = "and" then do: /* entering an and parenthesis */

                assign
                    iPredicateIdSeq                 = iPredicateIdSeq + 1
                    iParenthesisIdCurr              = iPredicateIdSeq
                    lParenthesisSub                 = yes

                    iPredicateCnt                   = iPredicateCnt + 1.

                create bParenthesis.
                assign
                    bParenthesis.hQuery             = phQuery
                    bParenthesis.iParenthesisId     = iParenthesisIdBaseOr
                    bParenthesis.iPredicateId       = iParenthesisIdCurr

                    bParenthesis.iPredicateSeq      = bParenthesis.iPredicateId
                    bParenthesis.cPredicateType     = "par"
                    bParenthesis.cPredicateExp      = ?

                    bParenthesis.cParenthesisType   = "and"
                    bParenthesis.lParenthesisNot    = no
                    bParenthesis.iPredicateCnt      = 0

                    bParenthesis.lLiteralValue      = ?

                    bParenthesis.hSimpleField       = ?
                    bParenthesis.iSimpleExtent      = ?
                    bParenthesis.cSimpleOperator    = ?

                    bParenthesis.hSimpleField2      = ?
                    bParenthesis.iSimpleExtent2     = ?
                    bParenthesis.cSimpleOperator2   = ?.

            end. /* cPrev = "or" and cOperator = "and" */
        
            else
            if cPrev = "and" and cOperator = "or" then do: /* returning from an and parenthesis */

                if iParenthesisIdBaseOr <> ? then

                    assign
                        iParenthesisIdCurr              = iParenthesisIdBaseOr
                        lParenthesisSub                 = no.

                else do:

                    assign
                        iPredicateIdSeq                 = iPredicateIdSeq + 1
                        iParenthesisIdBaseOr            = iPredicateIdSeq
                        lParenthesisSub                 = no

                        piParenthesisId                 = iParenthesisIdBaseOr
                        cParenthesisType                = "or".

                    create bParenthesis.
                    assign
                        bParenthesis.hQuery             = phQuery
                        bParenthesis.iParenthesisId     = iParenthesisIdBaseOr
                        bParenthesis.iPredicateId       = iParenthesisIdCurr /* previous and parenthesis id */

                        bParenthesis.iPredicateSeq      = bParenthesis.iPredicateId
                        bParenthesis.cPredicateType     = "par"
                        bParenthesis.cPredicateExp      = ?

                        bParenthesis.cParenthesisType   = "and"
                        bParenthesis.lParenthesisNot    = no
                        bParenthesis.iPredicateCnt      = iPredicateCnt

                        bParenthesis.lLiteralValue      = ?

                        bParenthesis.hSimpleField       = ?
                        bParenthesis.iSimpleExtent      = ?
                        bParenthesis.cSimpleOperator    = ?

                        bParenthesis.hSimpleField2      = ?
                        bParenthesis.iSimpleExtent2     = ?
                        bParenthesis.cSimpleOperator2   = ?.

                    assign
                        iParenthesisIdCurr              = iParenthesisIdBaseOr

                        iPredicateCnt                   = 1.

                end. /* else */

            end. /* cPrev = "and" and cOperator = "or" */



            if cParenthesisContent <> "" and lParenthesisNot <> ? then

            run parseParenthesis( 
                input   phQuery,
                input   iParenthesisIdCurr,
                input   lParenthesisNot,
                input   cParenthesisContent,
                output  i ).

            else

            run parsePredicate( 
                input phQuery,
                input iParenthesisIdCurr,
                input substr( pcParenthesis, iPrevEnd, iOperatorStart - iPrevEnd ) ).

            if lParenthesisSub then
               bParenthesis.iPredicateCnt = bParenthesis.iPredicateCnt + 1.
            else            iPredicateCnt = iPredicateCnt + 1.

            assign
                cPrev       = cOperator
                iPrevStart  = iOperatorStart
                iPrevEnd    = iOperatorEnd.

        end. /* repeat */

    end. /* for bParenthesis */

    if iOpenBracket > 0 then {err_throw "'qry_unclosed_bracket'"}.
    if iOpenExtent  > 0 then {err_throw "'qry_unclosed_square_bracket'"}.



    create ttWTree.
    assign
        ttWTree.hQuery              = phQuery
        ttWTree.iParenthesisId      = piParentId
        ttWTree.iPredicateId        = piParenthesisId

        ttWTree.iPredicateSeq       = ttWTree.iPredicateId
        ttWTree.cPredicateType      = "par"
        ttWTree.cPredicateExp       = ?

        ttWTree.cParenthesisType    = cParenthesisType
        ttWTree.lParenthesisNot     = plParenthesisNot
        ttWTree.iPredicateCnt       = iPredicateCnt

        ttWTree.lLiteralValue       = ?

        ttWTree.hSimpleField        = ?
        ttWTree.iSimpleExtent       = ?
        ttWTree.cSimpleOperator     = ?

        ttWTree.hSimpleField2       = ?
        ttWTree.iSimpleExtent2      = ?
        ttWTree.cSimpleOperator2    = ?.

end procedure. /* parseParenthesis */

procedure parsePredicate private:

    define input param phQuery          as handle no-undo.
    define input param piParenthesisId  as dec no-undo.
    define input param pcPredicate      as char no-undo.

    define buffer ttWTree for ttWTree.

    define var cPredicateExp    as char no-undo.

    define var lLiteralValue    as log no-undo.
    define var lLiteralNot      as log no-undo.

    define var hSimpleField     as handle no-undo.
    define var iSimpleExtent    as int no-undo.
    define var cSimpleOperator  as char no-undo.

    define var hSimpleField2    as handle no-undo.
    define var iSimpleExtent2   as int no-undo.
    define var cSimpleOperator2 as char no-undo.

    define var hField           as handle no-undo.
    define var iFieldExtent     as int no-undo.
    define var iFieldStart      as int no-undo.
    define var iFieldEnd        as int no-undo.
    define var cFieldTrail      as char no-undo.

    define var iPrevStart       as int no-undo.
    define var iPrevEnd         as int no-undo.

    define var lWordSep         as log no-undo.
    define var iLen             as int no-undo.
    define var iPos             as int no-undo.
    define var ch               as char no-undo.

    define var hndl             as handle no-undo.
    define var str              as char no-undo.
    define var i                as int no-undo.
    define var j                as int no-undo.

    assign
        pcPredicate = trim( pcPredicate )

        iPrevStart  = 1
        iPrevEnd    = iPrevStart

        lWordSep    = yes
        iLen        = length( pcPredicate )
        iPos         = 1.

    repeat while iPos <= iLen:

        assign
            hField          = ?
            iFieldExtent    = ?
            iFieldStart     = iLen + 1
            iFieldEnd       = iFieldStart.

        repeat while iPos <= iLen:

            ch = substr( pcPredicate, iPos, 1 ).

            if ch = '"' or ch = "'" then do:

                define var cQuote as char no-undo.

                assign
                    lWordSep    = yes
                    cQuote      = ch
                    iPos        = iPos + 1.

                repeat while iPos <= iLen:

                    ch = substr( pcPredicate, iPos, 1 ).

                    if ch = cQuote then do:

                        if substr( pcPredicate, iPos + 1, 1 ) = cQuote then

                            iPos = iPos + 2.

                        else do:

                            iPos = iPos + 1.

                            leave.

                        end. /* else */

                    end. /* ch = cQuote */

                    else
                    if ch = "~~" or ch = "~\" and opsys = "unix" then do:

                        ch = substr( pcPredicate, iPos + 1, 1 ).

                        if ch = '"' or ch = "'" or ch = "~~" or ch = "~\" then
                             iPos = iPos + 2.
                        else iPos = iPos + 1.

                    end. /* "~" */

                    else
                    iPos = iPos + 1.

                end. /* repeat */

                if iPos > iLen then
                    {err_throw "'qry_unmatched_quote'"}.

            end. /* '"' */



            else
            if ch = "~~" or ch = "~\" and opsys = "unix" then do:

                ch = substr( pcPredicate, iPos + 1, 1 ).

                if ch = '"' or ch = "'" then
                assign
                    lWordSep    = yes
                    iPos        = iPos + 2.

                if ch = "~~" or ch = "~\" then
                assign
                    lWordSep    = no
                    iPos        = iPos + 2.

                else
                assign
                    iPos        = iPos + 1.

            end. /* "~" */



            else
            if  ( ch >= "a" and ch <= "z" or ch = "_" /* system tables */ ) and lWordSep then do:

                define buffer ttBuffer for ttBuffer.

                define var cFieldName       as char no-undo.
                define var cFieldBuffer     as char no-undo.
                define var cFieldDatabase   as char no-undo.

                assign
                    i           = iPos

                    lWordSep    = no
                    iPos        = iPos + 1.

                repeat while iPos <= iLen:

                    ch = substr( pcPredicate, iPos, 1 ).

                    if not ( ch >= "a" and ch <= "z"
                          or ch >= "0" and ch <= "9"
                          or ch = "_" or ch = "-" or ch = "." ) then

                        leave.

                    iPos = iPos + 1.

                end. /* repeat */

                str = substr( pcPredicate, i, iPos - i ).

                if keyword( str ) <> ? then next.



                case num-entries( str, "." ):

                    when 1 then do:

                        assign
                            cFieldName = str.

                        open query qBuffer

                            for each  ttBuffer
                                where ttBuffer.hQuery = phQuery
                                use-index QueryBufferName.

                    end. /* num-entries = 1 */

                    when 2 then do:

                        assign
                            cFieldBuffer    = entry( 1, str, "." )
                            cFieldName      = entry( 2, str, "." ).

                        open query qBuffer

                            for each  ttBuffer
                                where ttBuffer.hQuery       = phQuery
                                  and ttBuffer.cBufferName  = cFieldBuffer
                                use-index QueryBufferName.

                    end. /* num-entries = 2 */

                    when 3 then do:

                        assign
                            cFieldDatabase  = entry( 1, str, "." )
                            cFieldBuffer    = entry( 2, str, "." )
                            cFieldName      = entry( 3, str, "." ).

                        open query qBuffer

                            for each  ttBuffer
                                where ttBuffer.hQuery       = phQuery
                                  and ttBuffer.cBufferName  = cFieldBuffer
                                  and ttBuffer.cDbName      = cFieldDatabase
                                use-index QueryBufferName.

                    end. /* num-entries = 3 */

                    otherwise next.

                end case. /* num-entries */

                repeat while query qBuffer:get-next( ):

                    hndl = ttBuffer.hBuffer:buffer-field( cFieldName ) no-error. 

                    if hndl <> ? then do:

                        if hField <> ? then
                            {err_throw "'qry_ambiguous_field'" str}.

                        assign
                            hField      = hndl
                            iFieldStart = i
                            iFieldEnd   = iPos.

                    end. /* hndl <> ? */

                end. /* repeat */

                if hField = ? then next.



                define var iExtent      as int no-undo.
                define var iExtentStart as int no-undo.
                define var iExtentEnd   as int no-undo.

                _Extent:

                do:

                    iExtentStart    = index( pcPredicate, "[", iFieldEnd ).
                    if iExtentStart = 0 or substr( pcPredicate, iFieldEnd, iExtentStart - iFieldEnd ) <> "" then leave _Extent.

                    iExtentEnd      = index( pcPredicate, "]", iExtentStart + 1 ).
                    if iExtentEnd   = 0 then leave _Extent.

                    iExtent         = ?. iExtent = int( trim( substr( pcPredicate, iExtentStart + 1, iExtentEnd - iExtentStart - 1 ) ) ) no-error.
                    if iExtent      = ? then leave _Extent.

                    if iExtent < 1 then 
                        {err_throw "'qry_extent_le_zero'" "substr( pcPredicate, iExtentStart, iExtentEnd - iExtentStart + 1 )"}.

                    assign
                        lWordSep        = yes

                        iFieldExtent    = iExtent
                        iFieldEnd       = iExtentEnd + 1.

                end. /* _Extent */

                leave.

            end. /* "a".."z" */



            else do:

                assign
                    lWordSep    = ( index( {&xWordSep}, ch ) > 0 )
                    iPos         = iPos + 1.

            end. /* else */

        end. /* repeat */



        cFieldTrail = substr( pcPredicate, iPrevEnd, iFieldStart - iPrevEnd ).

        if cFieldTrail <> "" or hField <> ? then

            cPredicateExp = cPredicateExp 

                + ( if cPredicateExp <> "" then chr(1) else "" )
                + cFieldTrail

                + ( if hField <> ?       then chr(1) + string( hField )       else "" )
                + ( if iFieldExtent <> ? then chr(2) + string( iFieldExtent ) else "" ).

        assign
            iPrevStart  = iFieldStart
            iPrevEnd    = iFieldEnd.

    end. /* repeat */



    define var iNumEntries as int no-undo.
    define var cExpression as char no-undo.

    iNumEntries = num-entries( cPredicateExp, chr(1) ).

    _PredicateType: 

    do:

        _Literal:

        do:

            if not iNumEntries = 1 then 
                leave _Literal.

            assign
                lLiteralNot = no

            j = num-entries( cPredicateExp, " " ). do i = 1 to j:

                str = entry( i, cPredicateExp, " " ). case str:

                    when "not" then
                        lLiteralNot = not lLiteralNot.

                       when "true"
                    or when "false"
                    or when "yes"
                    or when "no" then do:

                        if not i = j then leave _Literal.

                        case str:
    
                               when "true"
                            or when "yes"   then lLiteralValue = yes.

                               when "false"
                            or when "no"    then lLiteralValue = no.

                        end case. /* str */

                        if lLiteralNot then
                           lLiteralValue = not lLiteralValue.

                        leave.

                    end. /* yes/no */

                    otherwise
                    leave _Literal.

                end case. /* str */

            end. /* 1 to num-entries */



            iPredicateIdSeq = iPredicateIdSeq + 1.

            create ttLiteral.
            assign
                ttLiteral.iParenthesisId    = piParenthesisId
                ttLiteral.iPredicateId      = iPredicateIdSeq

                ttLiteral.lLiteralValue     = lLiteralValue.

            leave _PredicateType.

         end. /* _Literal */



        _Simple2: 

        do:

            if not ( iNumEntries = 4
                 and entry( 1, cPredicateExp, chr(1) ) = "" ) then

                leave _Simple2.

            str = entry( 2, cPredicateExp, chr(1) ).

            if num-entries( str, chr(2) ) = 1 then
            assign
                hSimpleField    = widget-handle( str )
                iSimpleExtent   = ?.

            else 
            assign
                hSimpleField    = widget-handle ( entry( 1, str, chr(2) ) )
                iSimpleExtent   = integer       ( entry( 2, str, chr(2) ) ).

            str = entry( 4, cPredicateExp, chr(1) ).

            if num-entries( str, chr(2) ) = 1 then
            assign
                hSimpleField2   = widget-handle( str )
                iSimpleExtent2  = ?.

            else 
            assign
                hSimpleField2   = widget-handle ( entry( 1, str, chr(2) ) )
                iSimpleExtent2  = integer       ( entry( 2, str, chr(2) ) ).



            case trim( entry( 3, cPredicateExp, chr(1) ) ):

                when "="  or when "eq" then
                assign
                    cSimpleOperator     = "="
                    cSimpleOperator2    = "=".

                when ">"  or when "gt" then
                assign
                    cSimpleOperator     = ">"
                    cSimpleOperator2    = "<".

                when "<"  or when "lt" then
                assign
                    cSimpleOperator     = "<"
                    cSimpleOperator2    = ">".

                when ">=" or when "ge" then
                assign
                    cSimpleOperator     = ">="
                    cSimpleOperator2    = "<=".

                when "<=" or when "le" then
                assign
                    cSimpleOperator     = "<="
                    cSimpleOperator2    = ">=".

                otherwise
                leave _Simple2.

            end case. /* entry(3) */



            iPredicateIdSeq = iPredicateIdSeq + 1.

            create ttWTree.
            assign
                ttWTree.hQuery              = phQuery
                ttWTree.iParenthesisId      = piParenthesisId
                ttWTree.iPredicateId        = iPredicateIdSeq

                ttWTree.iPredicateSeq       = ttWTree.iPredicateId
                ttWTree.cPredicateType      = "simple2"
                ttWTree.cPredicateExp       = ""

                ttWTree.cParenthesisType    = ?
                ttWTree.lParenthesisNot     = ?
                ttWTree.iPredicateCnt       = ?

                ttWTree.lLiteralValue       = ?

                ttWTree.hSimpleField        = hSimpleField
                ttWTree.iSimpleExtent       = iSimpleExtent
                ttWTree.cSimpleOperator     = cSimpleOperator

                ttWTree.hSimpleField2       = hSimpleField2
                ttWTree.iSimpleExtent2      = iSimpleExtent2
                ttWTree.cSimpleOperator2    = cSimpleOperator2.

            leave _PredicateType.

        end. /* _Simple2 */



        _Simple: 

        do:

            if not ( iNumEntries >= 3
                 and entry( 1, cPredicateExp, chr(1) ) = "" ) then

                leave _Simple.

            str = entry( 2, cPredicateExp, chr(1) ).

            if num-entries( str, chr(2) ) = 1 then
            assign
                hSimpleField    = widget-handle( str )
                iSimpleExtent   = ?.

            else 
            assign
                hSimpleField    = widget-handle ( entry( 1, str, chr(2) ) )
                iSimpleExtent   = integer       ( entry( 2, str, chr(2) ) ).



            cExpression = left-trim( entry( 3, cPredicateExp, chr(1) ) ).

            if  length( cExpression ) >= 3
            and lookup( substr( cExpression, 1, 2 ), ">=,<=" ) > 0 then

            assign
                cSimpleOperator = substr( cExpression, 1, 2 )

                cExpression     = left-trim( substr( cExpression, 3 ) ).

            else
            if  length( cExpression ) >= 2
            and lookup( substr( cExpression, 1, 1 ), "=,>,<" ) > 0 then

            assign
                cSimpleOperator = substr( cExpression, 1, 1 )

                cExpression     = left-trim( substr( cExpression, 2 ) ).

            else
            if  length( cExpression ) >= 4
            and lookup( substr( cExpression, 1, 2 ), "eq,gt,lt,ge,le" ) > 0 and index ( {&xWordSep}, substr( cExpression, 3, 1 ) ) > 0 then

            assign
                str             = substr( cExpression, 1, 2 )

                cSimpleOperator = ( if str = "eq" then "="  else
                                  ( if str = "gt" then ">"  else
                                  ( if str = "lt" then "<"  else
                                  ( if str = "ge" then ">=" else
                                  ( if str = "le" then "<=" else ? ) ) ) ) )

                cExpression     = left-trim( substr( cExpression, 3 ) ).

            else
            if  length( cExpression ) >= 8
            and substr( cExpression, 1, 6 ) = "begins" and index ( {&xWordSep}, substr( cExpression, 7, 1 ) ) > 0 then

            assign
                cSimpleOperator = "begins"

                cExpression     = left-trim( substr( cExpression, 7 ) ).

            else
            leave _Simple.



            do i = 4 to iNumEntries:

                if i mod 2 = 0 then do:

                    hndl = widget-handle( entry( 1, entry( i, cPredicateExp, chr(1) ), chr(2) ) ).

                    if hndl:buffer-handle = hSimpleField:buffer-handle then
                        leave _Simple.

                end. /* i mod 2 = 0 */

                cExpression = cExpression + chr(1) + entry( i, cPredicateExp, chr(1) ).

            end. /* 4 to iNumEntries */



            iPredicateIdSeq = iPredicateIdSeq + 1.

            create ttWTree.
            assign
                ttWTree.hQuery              = phQuery
                ttWTree.iParenthesisId      = piParenthesisId
                ttWTree.iPredicateId        = iPredicateIdSeq

                ttWTree.iPredicateSeq       = ttWTree.iPredicateId
                ttWTree.cPredicateType      = "simple"
                ttWTree.cPredicateExp       = cExpression

                ttWTree.cParenthesisType    = ?
                ttWTree.lParenthesisNot     = ?
                ttWTree.iPredicateCnt       = ?

                ttWTree.lLiteralValue       = ?

                ttWTree.hSimpleField        = hSimpleField
                ttWTree.iSimpleExtent       = iSimpleExtent
                ttWTree.cSimpleOperator     = cSimpleOperator

                ttWTree.hSimpleField2       = ?
                ttWTree.iSimpleExtent2      = ?
                ttWTree.cSimpleOperator2    = ?.

            leave _PredicateType.

        end. /* _Simple */



        _ReverseSimple:

        do:

            if not ( iNumEntries >= 2
                 and iNumEntries mod 2 = 0 ) then

                leave _ReverseSimple.

            str = left-trim( entry( 1, cPredicateExp, chr(1) ) ).

            if not ( length( str ) >= 4
                 and substr( str, 1, 3 ) = "not" and index ( {&xWordSep}, substr( cExpression, 4, 1 ) ) > 0 ) then

                leave _ReverseSimple.

            str = entry( iNumEntries, cPredicateExp, chr(1) ).

            if num-entries( str, chr(2) ) = 1 then
            assign
                hSimpleField    = widget-handle( str )
                iSimpleExtent   = ?.

            else
            assign
                hSimpleField    = widget-handle ( entry( 1, str, chr(2) ) )
                iSimpleExtent   = integer       ( entry( 2, str, chr(2) ) ).



            assign
                cExpression = right-trim( entry( iNumEntries - 1, cPredicateExp, chr(1) ) )

            i = length( cExpression ).

            if  i >= 3
            and lookup( substr( cExpression, i - 1, 2 ), ">=,<=" ) > 0 then

            assign
                str             = substr( cExpression, i - 1, 2 )

                cSimpleOperator = ( if str = ">=" then "<=" else
                                  ( if str = "<=" then ">=" else ? ) )

                cExpression     = right-trim( substr( cExpression, 1, i - 2 ) ).

            else
            if  i >= 2
            and lookup( substr( cExpression, i, 1 ), "=,>,<" ) > 0 then

            assign
                str             = substr( cExpression, i, 1 )

                cSimpleOperator = ( if str = "=" then "=" else
                                  ( if str = ">" then "<" else
                                  ( if str = "<" then ">" else ? ) ) )

                cExpression     = right-trim( substr( cExpression, 1, i - 1 ) ).

            else
            if  i >= 4
            and lookup( substr( cExpression, i - 1, 2 ), "eq,gt,lt,ge,le" ) > 0 and index( {&xWordSep}, substr( cExpression, i - 2, 1 ) ) > 0 then

            assign
                str             = substr( cExpression, i - 1, 2 )

                cSimpleOperator = ( if str = "eq" then "="  else
                                  ( if str = "lt" then ">"  else
                                  ( if str = "gt" then "<"  else
                                  ( if str = "le" then ">=" else
                                  ( if str = "ge" then "<=" else ? ) ) ) ) )

                cExpression     = right-trim( substr( cExpression, 1, i - 2 ) ).

            else
            leave _ReverseSimple.



            do i = iNumEntries - 2 to 1 by -1:

                if i mod 2 = 0 then do:

                    hndl = widget-handle( entry( 1, entry( i, cPredicateExp, chr(1) ), chr(2) ) ).

                    if hndl:buffer-handle = hSimpleField:buffer-handle then
                        leave _ReverseSimple.

                end. /* i mod 2 = 0 */

                cExpression = entry( i, cPredicateExp, chr(1) ) + chr(1) + cExpression.

            end. /* iNumEntries - 2 to 1 */



            iPredicateIdSeq = iPredicateIdSeq + 1.

            create ttWTree.
            assign
                ttWTree.hQuery              = phQuery
                ttWTree.iParenthesisId      = piParenthesisId
                ttWTree.iPredicateId        = iPredicateIdSeq

                ttWTree.iPredicateSeq       = ttWTree.iPredicateId
                ttWTree.cPredicateType      = "simple"
                ttWTree.cPredicateExp       = cExpression

                ttWTree.cParenthesisType    = ?
                ttWTree.lParenthesisNot     = ?
                ttWTree.iPredicateCnt       = ?

                ttWTree.lLiteralValue       = ?

                ttWTree.hSimpleField        = hSimpleField
                ttWTree.iSimpleExtent       = iSimpleExtent
                ttWTree.cSimpleOperator     = cSimpleOperator

                ttWTree.hSimpleField2       = ?
                ttWTree.iSimpleExtent2      = ?
                ttWTree.cSimpleOperator2    = ?.

            leave _PredicateType.

        end. /* _ReverseSimple */



        _Expression:

        do:

            iPredicateIdSeq = iPredicateIdSeq + 1.

            create ttWTree.
            assign
                ttWTree.hQuery              = phQuery
                ttWTree.iParenthesisId      = piParenthesisId
                ttWTree.iPredicateId        = iPredicateIdSeq

                ttWTree.iPredicateSeq       = ttWTree.iPredicateId
                ttWTree.cPredicateType      = "exp"
                ttWTree.cPredicateExp       = cPredicateExp /* the original predicate expression */

                ttWTree.cParenthesisType    = ?
                ttWTree.lParenthesisNot     = ?
                ttWTree.iPredicateCnt       = ?

                ttWTree.lLiteralValue       = ?

                ttWTree.hSimpleField        = ?
                ttWTree.iSimpleExtent       = ?
                ttWTree.cSimpleOperator     = ?

                ttWTree.hSimpleField2       = ?
                ttWTree.iSimpleExtent2      = ?
                ttWTree.cSimpleOperator2    = ?.

            leave _PredicateType.

        end. /* _Expression */

    end. /* _PredicateType */

end procedure. /* parsePredicate */



function isFakeFirstLast returns log private

    ( phBuffer  as handle, 
      piWhereId as {&xSequence} ):

    define buffer ttWTree for ttWTree.

    define var cIndexInfo   as char no-undo.
    define var iIndexNum    as int no-undo.

    define var cFieldList   as char no-undo.
    define var cFieldName   as char no-undo.

    define var i            as int no-undo.
    define var j            as int no-undo. 

    if not can-find(

       first ttWTree
       where ttWTree.iPredicateId       = piWhereId
         and ttWTree.cPredicateType     = "par"
         and ( ttWTree.cParenthesisType = "and"
            or ttWTree.cParenthesisType = "single" )
         and ttWTree.lParenthesisNot    = no

       use-index iPredicateId ) then return no.



    cFieldList = "".

    for each  ttWTree
        where ttWTree.iParenthesisId    = piWhereId
          and ( ttWTree.cPredicateType  = "simple" 
             or ttWTree.cPredicateType  = "simple2" )
            and ttWTree.cSimpleOperator = "="

        use-index WTree:

        if  ttWTree.hSimpleField:buffer-handle  = phBuffer then

             cFieldName = ttWTree.hSimpleField:name.

        else
        if  ttWTree.cPredicateType              = "simple2"
        and ttWTree.hSimpleField2:buffer-handle = phBuffer then

             cFieldName = ttWTree.hSimpleField2:name.

        else next.

        if lookup( cFieldName, cFieldList ) = 0 then
        cFieldList = cFieldList

            + ( if cFieldList <> "" then "," else "" )
            + cFieldName.

    end. /* for each */

    if cFieldList = "" then return no.



    iIndexNum = 1.

    repeat:

        cIndexInfo = phBuffer:index-information( iIndexNum ) no-error. if cIndexInfo = ? then leave.

        if entry( 3, cIndexInfo ) = "1" then

        _Fake:

        do:

            j = num-entries( cIndexInfo ). do i = 5 to j by 2:

                cFieldName = entry( i, cIndexInfo ).
                if lookup( cFieldName, cFieldList ) = 0 then leave _Fake.

            end. /* 5 to j */

            return yes.

        end. /* _Fake */

        iIndexNum = iIndexNum + 1.

    end. /* repeat */

    return no.

end function. /* isFakeFirstLast */



procedure refineLiterals private:

    define input param phQuery      as handle no-undo.
    define input param piWhereId    as {&xSequence} no-undo.

    define buffer ttWTree   for ttWTree.
    define buffer ttLiteral for ttLiteral.

    define var hQuery as handle no-undo.



    find first ttLiteral use-index WTree no-error.

    repeat while avail ttLiteral:

        find first ttWTree
             where ttWTree.iPredicateId = ttLiteral.iParenthesisId
             use-index iPredicateId
             no-error.

        if ttWTree.cParenthesisType = "and" and ttLiteral.lLiteralValue = yes
        or ttWTree.cParenthesisType = "or"  and ttLiteral.lLiteralValue = no then do:

            delete ttLiteral.

            ttWTree.iPredicateCnt = ttWTree.iPredicateCnt - 1.

            if ttWTree.iPredicateCnt = 1 then
               ttWTree.cParenthesisType = "single".

        end. /* and/yes */

        else

        if ttWTree.cParenthesisType = "and" and ttLiteral.lLiteralValue = no
        or ttWTree.cParenthesisType = "or"  and ttLiteral.lLiteralValue = yes
        or ttWTree.cParenthesisType = "single" then do:

            define var lLiteralValue as log no-undo.

            if ttWTree.lParenthesisNot then
                 lLiteralValue = not ttLiteral.lLiteralValue.
            else lLiteralValue =     ttLiteral.lLiteralValue.

            delete ttLiteral.



            if ttWTree.iPredicateId <> piWhereId then do:

                create ttLiteral.

                buffer-copy ttWTree to ttLiteral
                    assign
                        ttLiteral.lLiteralValue = lLiteralValue.

                run deleteParenthesis( ttWTree.iPredicateId ).

            end. /* iPredicateId <> piWhereId */

            else do:

                run deleteParenthesis( ttWTree.iPredicateId ).

                create ttWTree.
                assign
                    ttWTree.hQuery              = phQuery
                    ttWTree.iParenthesisId      = ?
                    ttWTree.iPredicateId        = piWhereId

                    ttWTree.iPredicateSeq       = ttWTree.iPredicateId
                    ttWTree.cPredicateType      = "literal"
                    ttWTree.cPredicateExp       = ?

                    ttWTree.cParenthesisType    = ?
                    ttWTree.lParenthesisNot     = ?
                    ttWTree.iPredicateCnt       = ?

                    ttWTree.lLiteralValue       = lLiteralValue

                    ttWTree.hSimpleField        = ?
                    ttWTree.iSimpleExtent       = ?
                    ttWTree.cSimpleOperator     = ?

                    ttWTree.hSimpleField2       = ?
                    ttWTree.iSimpleExtent2      = ?
                    ttWTree.cSimpleOperator2    = ?.

            end. /* else */

        end. /* and/no */

        find first ttLiteral use-index WTree no-error.

    end. /* repeat */

end procedure. /* refineLiterals */

procedure refineParenthesis private:

    define input-output param piParenthesisId as {&xSequence} no-undo.

    define buffer ttWTree       for ttWTree.
    define buffer bParenthesis  for ttWTree.

    define var iParenthesisId   as {&xSequence} no-undo.
    define var lParenthesisNot  as log no-undo.



    find first ttWTree
         where ttWTree.iPredicateId = piParenthesisId
         use-index iPredicateId
         no-error.

    if ttWTree.cPredicateType <> "par" then
        return.

    if ttWTree.cParenthesisType = "single" then
    do for bParenthesis:

        assign
            iParenthesisId  = ttWTree.iPredicateId
            lParenthesisNot = ttWTree.lParenthesisNot.

        repeat:

            if can-find( 
                first bParenthesis
                where bParenthesis.iParenthesisId = iParenthesisId
                  and bParenthesis.cPredicateType = "par"
                use-index WTree ) then do:

                if avail ttWTree then
                     delete ttWTree.
                else delete bParenthesis.

                find first bParenthesis
                     where bParenthesis.iParenthesisId = iParenthesisId
                     use-index WTree
                     no-error.

                assign
                    iParenthesisId  = bParenthesis.iPredicateId
                    lParenthesisNot = 

                        ( if bParenthesis.lParenthesisNot then
                           not lParenthesisNot
                          else lParenthesisNot ).

                if bParenthesis.cParenthesisType <> "single" then leave.

            end. /* can-find */

            else leave.

        end. /* repeat */



        if not avail ttWTree then do:

            find first ttWTree
                 where ttWTree.iPredicateId = iParenthesisId
                 use-index iPredicateId
                 no-error.

            assign
                piParenthesisId         = ttWTree.iPredicateId

                ttWTree.iParenthesisId  = ?
                ttWTree.lParenthesisNot = lParenthesisNot.

        end. /* not avail */

    end. /* single */

    run refineParenthesisRecurr(
        input           ttWTree.iParenthesisId,
        input           ttWTree.cParenthesisType,
        input-output    ttWTree.iPredicateCnt ).

end procedure. /* refineParenthesis */

procedure refineParenthesisRecurr private:

    define input        param piParenthesisId   as {&xSequence} no-undo.
    define input        param pcParenthesisType as char no-undo.
    define input-output param piPredicateCnt    as int no-undo.

    define buffer ttWTree       for ttWTree.
    define buffer bParenthesis  for ttWTree.

    define var iParenthesisId   as {&xSequence} no-undo.
    define var lParenthesisNot  as log no-undo.
    define var rReposition      as rowid no-undo.

    define query qWTree

        for ttWTree scrolling.

    open query qWTree

        preselect each ttWTree
                 where ttWTree.iParenthesisId = piParenthesisId
                   and ttWTree.cPredicateType = "par"
                 use-index WTree.

    get first qWTree.

    repeat while query qWTree:query-off-end:

        if ttWTree.cParenthesisType = "single" then
        do for bParenthesis:

            assign
                iParenthesisId  = ttWTree.iPredicateId
                lParenthesisNot = ttWTree.lParenthesisNot.

            repeat:

                if can-find( 
                    first bParenthesis
                    where bParenthesis.iParenthesisId = iParenthesisId
                      and bParenthesis.cPredicateType = "par"
                    use-index WTree ) then do:

                    if avail ttWTree then
                         delete ttWTree.
                    else delete bParenthesis.

                    find first bParenthesis
                         where bParenthesis.iParenthesisId = iParenthesisId
                         use-index WTree
                         no-error.

                    assign
                        iParenthesisId  = bParenthesis.iPredicateId
                        lParenthesisNot = 

                            ( if bParenthesis.lParenthesisNot then
                               not lParenthesisNot
                              else lParenthesisNot ).

                    if bParenthesis.cParenthesisType <> "single" then leave.

                end. /* can-find */

                else leave.

            end. /* repeat */



            if not avail ttWTree then do:

                find first ttWTree
                     where ttWTree.iPredicateId = iParenthesisId
                     use-index iPredicateId
                     no-error.

                assign
                    ttWTree.iParenthesisId  = piParenthesisId
                    ttWTree.lParenthesisNot = lParenthesisNot.

                query qWTree:create-result-list-entry( ).

            end. /* not avail */

        end. /* single */



        if ( ttWTree.cParenthesisType = pcParenthesisType or ttWTree.cParenthesisType = "single" )

         and ttWTree.lParenthesisNot = no then do:

            assign
                piPredicateCnt  = piPredicateCnt - 1 + ttWTree.iPredicateCnt

                iParenthesisId  = ttWTree.iPredicateId
                rReposition     = ?.

            query qWTree:delete-result-list-entry( ).

            delete ttWTree.



            find first ttWTree
                 where ttWTree.iParenthesisId = iParenthesisId
                 use-index WTree
                 no-error.

            repeat while avail ttWTree.

                ttWTree.iParenthesisId = piParenthesisId.

                if ttWTree.cPredicateType = "par" then do:
                
                    query qWTree:create-result-list-entry( ).

                    if rReposition = ? then
                       rReposition = rowid( ttWTree ).

                end. /* par */

                find next ttWTree
                    where ttWTree.iParenthesisId = iParenthesisId
                    use-index WTree
                    no-error.

            end. /* repeat */

            if rReposition <> ? then
                reposition qWTree to rowid rReposition.

        end. /* ttWTree.cParenthesisType = pcParenthesisType */



        else

        run refineParenthesisRecurr(
            input           ttWTree.iParenthesisId,
            input           ttWTree.cParenthesisType,
            input-output    ttWTree.iPredicateCnt ).

        get next qWTree.

    end. /* repeat */

end procedure. /* refineParenthesisReCurr */

procedure refineJoins private:

    /* refineJoins assumes that the parenthesis have been refined and must be runned after refineParenthesis.
       and only checks the main and or single where clause. */

    define input-output param piWhereId as {&xSequence} no-undo.

    define buffer ttWTree       for ttWTree.
    define buffer bParenthesis  for ttWTree.

    define buffer bField1       for ttJoinField.
    define buffer bField2       for ttJoinField.

    find first bParenthesis
         where bParenthesis.iPredicateId = piWhereId
         use-index iPredicateId
         no-error.

    if not ( bParenthesis.cPredicateType    = "par"
       and ( bParenthesis.cParenthesisType  = "and"
          or bParenthesis.cParenthesisType  = "single" ) ) then return.

    for each  ttWTree
        where ttWTree.iParenthesisId    = bParenthesis.iPredicateId
          and ttWTree.cParenthesisType  = "simple2"
          and ttWTree.cSimpleOperator   = "="
        use-index WTree:



        find first bField1
             where bField1.hQuery       = ttWTree.hQuery
               and bField1.hField       = ttWTree.hSimpleField
               and bField1.iFieldExtent = ttWTree.iSimpleExtent
             use-index QueryField
             no-error.

        find first bField2
             where bField2.hQuery       = ttWTree.hQuery
               and bField2.hField       = ttWTree.hSimpleField2
               and bField2.iFieldExtent = ttWTree.iSimpleExtent2
             use-index QueryField
             no-error.

        if not avail bField1 and not avail bField2 then do:

            iJoinIdSeq = iJoinIdSeq + 1.

            create bField1.
            assign
                bField1.hQuery          = ttWTree.hQuery
                bField1.hBuffer         = ttWTree.hSimpleField:buffer-handle
                bField1.hField          = ttWTree.hSimpleField
                bField1.cFieldName      = ttWTree.hSimpleField:name
                bField1.iFieldExtent    = ttWTree.iSimpleExtent

                bField1.iJoinId         = iJoinIdSeq

                bField1.iPredicateId    = ttWTree.iPredicateId
                bField1.iPredicateSeq   = ttWTree.iPredicateSeq
                bField1.cDataType       = ttWTree.hSimpleField:data-type.

            create bField2.
            assign
                bField2.hQuery          = ttWTree.hQuery
                bField2.hBuffer         = ttWTree.hSimpleField2:buffer-handle
                bField2.hField          = ttWTree.hSimpleField2
                bField2.cFieldName      = ttWTree.hSimpleField2:name
                bField2.iFieldExtent    = ttWTree.iSimpleExtent2

                bField2.iJoinId         = iJoinIdSeq

                bField2.iPredicateId    = ttWTree.iPredicateId
                bField2.iPredicateSeq   = ttWTree.iPredicateSeq
                bField2.cDataType       = ttWTree.hSimpleField2:data-type.

        end. /* not avail and not avail */

        else
        if not avail bField1 and avail bField2 then do:

            create bField1.
            assign
                bField1.hQuery          = ttWTree.hQuery
                bField1.hBuffer         = ttWTree.hSimpleField:buffer-handle
                bField1.hField          = ttWTree.hSimpleField
                bField1.cFieldName      = ttWTree.hSimpleField:name
                bField1.iFieldExtent    = ttWTree.iSimpleExtent

                bField1.iJoinId         = bField2.iJoinId

                bField1.iPredicateId    = ttWTree.iPredicateId
                bField1.iPredicateSeq   = ttWTree.iPredicateSeq
                bField1.cDataType       = ttWTree.hSimpleField:data-type.

        end. /* not avail and avail */

        else
        if avail bField1 and not avail bField2 then do:

            create bField2.
            assign
                bField2.hQuery          = ttWTree.hQuery
                bField2.hBuffer         = ttWTree.hSimpleField2:buffer-handle
                bField2.hField          = ttWTree.hSimpleField2
                bField2.cFieldName      = ttWTree.hSimpleField2:name
                bField2.iFieldExtent    = ttWTree.iSimpleExtent2

                bField2.iJoinId         = bField1.iJoinId

                bField2.iPredicateId    = ttWTree.iPredicateId
                bField2.iPredicateSeq   = ttWTree.iPredicateSeq
                bField2.cDataType       = ttWTree.hSimpleField2:data-type.

        end. /* avail and not avail */

        else
        if  avail bField1 and avail bField2

        and bField1.iJoinId <> bField2.iJoinId then do:

            define var iJoinId as {&xSequence} no-undo.

            iJoinId = bField2.iJoinId.

            for each  bField2
                where bField2.iJoinId = iJoinId
                use-index JoinBuffer:

                bField2.iJoinId = bField1.iJoinId.

            end. /* for each */

        end. /* avail and avail */



        bParenthesis.iPredicateCnt = bParenthesis.iPredicateCnt - 1.

        delete ttWTree.

        if bParenthesis.iPredicateCnt = 1 then
           bParenthesis.cParenthesisType = "single".

        else
        if bParenthesis.iPredicateCnt = 0 then do:

            piWhereId = ?.

            delete bParenthesis.

        end. /* iPredicateCnt = 0 */

    end. /* for each */

end procedure. /* refineJoins */



procedure joinParenthesisByAnd private:

    define input-output param piParenthesisId1 as {&xSequence} no-undo.
    define input        param piParenthesisId2 as {&xSequence} no-undo.

    define buffer ttWTree       for ttWTree.
    define buffer bParenthesis1 for ttWTree.
    define buffer bParenthesis2 for ttWTree.

    define var lAnd1 as log no-undo.
    define var lAnd2 as log no-undo.

    if piParenthesisId1 = ? and piParenthesisId2 = ? then do:
                            
        piParenthesisId1 = ?.        
        return.

    end. /* piParenthesisId1 = ? and piParenthesisId2 = ? */

    else
    if piParenthesisId1 = ? then do:

        piParenthesisId1 = piParenthesisId2.
        return.
    
    end. /* piParenthesisId1 = ? */

    else
    if piParenthesisId2 = ? then do:

        piParenthesisId1 = piParenthesisId1.
        return.
    
    end. /* piParenthesisId2 = ? */



    find first bParenthesis1
         where bParenthesis1.iPredicateId = piParenthesisId1
         use-index iPredicateId
         no-error.

    find first bParenthesis2
         where bParenthesis2.iPredicateId = piParenthesisId2
         use-index iPredicateId
         no-error.

    if  bParenthesis1.cPredicateType = "literal" 
    and bParenthesis1.lLiteralValue  = no then do:

        if bParenthesis2.cPredicateType = "par" then
            run deleteParenthesis( bParenthesis2.iPredicateId ).

        else
        delete bParenthesis2.

        piParenthesisId1 = bParenthesis1.iPredicateId.
        return.
        
    end. /* lLiteralValue = no */

    else
    if  bParenthesis2.cPredicateType = "literal" 
    and bParenthesis2.lLiteralValue  = no then do:

        if bParenthesis1.cPredicateType = "par" then
            run deleteParenthesis( bParenthesis1.iPredicateId ).

        else
        delete bParenthesis1.

        piParenthesisId1 = bParenthesis2.iPredicateId.
        return.

    end. /* lLiteralValue = no */



    assign
        lAnd1 = ( bParenthesis1.cParenthesisType = "and" 
               or bParenthesis1.cParenthesisType = "single" )
              and bParenthesis1.lParenthesisNot  = no 

        lAnd2 = ( bParenthesis2.cParenthesisType = "and" 
               or bParenthesis2.cParenthesisType = "single" )
              and bParenthesis2.lParenthesisNot  = no.

    if lAnd1 and lAnd2 then do:

        if bParenthesis1.iPredicateCnt <= bParenthesis2.iPredicateCnt then do:

            assign
                piParenthesisId1            = bParenthesis1.iPredicateId

                bParenthesis1.iPredicateCnt = 
                    bParenthesis1.iPredicateCnt +
                    bParenthesis2.iPredicateCnt.

            for each  ttWTree
                where ttWTree.iParenthesisId = bParenthesis2.iPredicateId 
                use-index WTree:

                ttWTree.iParenthesisId = bParenthesis1.iPredicateId.

            end. /* for each */

            delete bParenthesis2.

        end. /* iPredicateCnt <= */

        else do:

            assign
                piParenthesisId1            = bParenthesis2.iPredicateId

                bParenthesis2.iPredicateCnt = 
                    bParenthesis2.iPredicateCnt +
                    bParenthesis1.iPredicateCnt.

            for each  ttWTree
                where ttWTree.iParenthesisId = bParenthesis1.iPredicateId 
                use-index WTree:

                ttWTree.iParenthesisId = bParenthesis2.iPredicateId.

            end. /* for each */

            delete bParenthesis1.

        end. /* else do */

    end. /* lAnd1 and lAnd2 */



    else
    if lAnd1 and not lAnd2 then do:

        assign
            piParenthesisId1                = bParenthesis1.iPredicateId

            bParenthesis1.iPredicateCnt     = bParenthesis1.iPredicateCnt + 1
            bParenthesis2.iParenthesisId    = bParenthesis1.iPredicateId.

    end. /* lAnd and not lAnd2 */

    else
    if not lAnd1 and lAnd2 then do:

        assign
            piParenthesisId1                = bParenthesis2.iPredicateId

            bParenthesis2.iPredicateCnt     = bParenthesis2.iPredicateCnt + 1
            bParenthesis1.iParenthesisId    = bParenthesis2.iPredicateId.

    end. /* not lAnd1 and lAnd2 */



    else
    if not lAnd1 and not lAnd2 then do:

        iPredicateIdSeq = iPredicateIdSeq + 1.

        create ttWTree.
        assign
            ttWTree.hQuery                  = bParenthesis1.hQuery
            ttWTree.iParenthesisId          = ?
            ttWTree.iPredicateId            = iPredicateIdSeq

            ttWTree.iPredicateSeq           = min( bParenthesis1.iPredicateSeq, bParenthesis2.iPredicateSeq )
            ttWTree.cPredicateType          = "par"
            ttWTree.cPredicateExp           = ?

            ttWTree.cParenthesisType        = "and"
            ttWTree.lParenthesisNot         = no
            ttWTree.iPredicateCnt           = 2

            ttWTree.lLiteralValue           = ?

            ttWTree.hSimpleField            = ?
            ttWTree.iSimpleExtent           = ?
            ttWTree.cSimpleOperator         = ?

            ttWTree.hSimpleField2           = ?
            ttWTree.iSimpleExtent2          = ?
            ttWTree.cSimpleOperator2        = ?.

        assign
            piParenthesisId1                = ttWTree.iPredicateId

            bParenthesis1.iParenthesisId    = ttWTree.iPredicateId
            bParenthesis2.iParenthesisId    = ttWTree.iPredicateId.

    end. /* not lAnd1 and not lAnd2 */

end procedure. /* joinParenthesisByAnd */

procedure copyParenthesisByAnd private:

    define input-output param piParenthesisId1 as {&xSequence} no-undo.
    define input        param piParenthesisId2 as {&xSequence} no-undo.

    define buffer ttWTree       for ttWTree.
    define buffer bParenthesis1 for ttWTree.
    define buffer bParenthesis2 for ttWTree.

    define var lAnd1 as log no-undo.
    define var lAnd2 as log no-undo.

    if piParenthesisId1 = ? and piParenthesisId2 = ? then do:
                            
        piParenthesisId1 = ?.        
        return.

    end. /* piParenthesisId1 = ? and piParenthesisId2 = ? */

    else
    if piParenthesisId1 = ? then do:

        piParenthesisId1 = piParenthesisId2.
        return.
    
    end. /* piParenthesisId1 = ? */

    else
    if piParenthesisId2 = ? then do:

        piParenthesisId1 = piParenthesisId1.
        return.
    
    end. /* piParenthesisId2 = ? */



    find first bParenthesis1
         where bParenthesis1.iPredicateId = piParenthesisId1
         use-index iPredicateId
         no-error.

    find first bParenthesis2
         where bParenthesis2.iPredicateId = piParenthesisId2
         use-index iPredicateId
         no-error.

    if  bParenthesis1.cPredicateType = "literal" 
    and bParenthesis1.lLiteralValue  = no then do:

        piParenthesisId1 = bParenthesis1.iPredicateId.
        return.
        
    end. /* lLiteralValue = no */

    else
    if  bParenthesis2.cPredicateType = "literal" 
    and bParenthesis2.lLiteralValue  = no then do:

        iPredicateIdSeq = iPredicateIdSeq + 1.

        create ttWTree.
        assign
            ttWTree.hQuery              = bParenthesis1.hQuery
            ttWTree.iParenthesisId      = ?
            ttWTree.iPredicateId        = iPredicateIdSeq

            ttWTree.iPredicateSeq       = bParenthesis1.iPredicateSeq
            ttWTree.cPredicateType      = "literal"
            ttWTree.cPredicateExp       = ?

            ttWTree.cParenthesisType    = ?
            ttWTree.lParenthesisNot     = ?
            ttWTree.iPredicateCnt       = ?

            ttWTree.lLiteralValue       = no

            ttWTree.hSimpleField        = ?
            ttWTree.iSimpleExtent       = ?
            ttWTree.cSimpleOperator     = ?

            ttWTree.hSimpleField2       = ?
            ttWTree.iSimpleExtent2      = ?
            ttWTree.cSimpleOperator2    = ?.

        if bParenthesis1.cPredicateType = "par" then
            run deleteParenthesis( bParenthesis1.iPredicateId ).

        else
        delete bParenthesis1.

        piParenthesisId1 = ttWTree.iPredicateId.
        return.

    end. /* lLiteralValue = no */



    assign
        lAnd1 = ( bParenthesis1.cParenthesisType = "and" 
               or bParenthesis1.cParenthesisType = "single" )
              and bParenthesis1.lParenthesisNot  = no 

        lAnd2 = ( bParenthesis2.cParenthesisType = "and" 
               or bParenthesis2.cParenthesisType = "single" )
              and bParenthesis2.lParenthesisNot  = no.

    if lAnd1 and lAnd2 then do:

        run copyPredicates(
            input bParenthesis1.iPredicateId,
            input bParenthesis2.iPredicateId ).

        assign
            piParenthesisId1                = bParenthesis1.iPredicateId

            bParenthesis1.iPredicateCnt     = bParenthesis1.iPredicateCnt + bParenthesis2.iPredicateCnt.

    end. /* lAnd1 and lAnd2 */

    else
    if lAnd1 and not lAnd2 then do:

        run copyParenthesis(
            input bParenthesis1.iPredicateId,
            input bParenthesis2.iPredicateId ).

        assign
            piParenthesisId1                = bParenthesis1.iPredicateId

            bParenthesis1.iPredicateCnt     = bParenthesis1.iPredicateCnt + 1.

    end. /* lAnd and not lAnd2 */



    else
    if not lAnd1 and lAnd2 then do:

        iPredicateIdSeq = iPredicateIdSeq + 1.

        create ttWTree.
        assign
            ttWTree.hQuery                  = bParenthesis1.hQuery
            ttWTree.iParenthesisId          = ?
            ttWTree.iPredicateId            = iPredicateIdSeq

            ttWTree.iPredicateSeq           = min( bParenthesis1.iPredicateSeq, bParenthesis2.iPredicateSeq )
            ttWTree.cPredicateType          = "par"
            ttWTree.cPredicateExp           = ?

            ttWTree.cParenthesisType        = "and"
            ttWTree.lParenthesisNot         = no
            ttWTree.iPredicateCnt           = bParenthesis2.iPredicateCnt + 1

            ttWTree.lLiteralValue           = ?

            ttWTree.hSimpleField            = ?
            ttWTree.iSimpleExtent           = ?
            ttWTree.cSimpleOperator         = ?

            ttWTree.hSimpleField2           = ?
            ttWTree.iSimpleExtent2          = ?
            ttWTree.cSimpleOperator2        = ?.

        assign
            piParenthesisId1                = ttWTree.iPredicateId

            bParenthesis1.iParenthesisId    = ttWTree.iPredicateId.

        run copyPredicates(
            input ttWTree.iPredicateId,
            input bParenthesis2.iPredicateId ).

    end. /* not lAnd1 and lAnd2 */

    else
    if not lAnd1 and not lAnd2 then do:

        iPredicateIdSeq = iPredicateIdSeq + 1.

        create ttWTree.
        assign
            ttWTree.hQuery                  = bParenthesis1.hQuery
            ttWTree.iParenthesisId          = ?
            ttWTree.iPredicateId            = iPredicateIdSeq

            ttWTree.iPredicateSeq           = min( bParenthesis1.iPredicateSeq, bParenthesis2.iPredicateSeq )
            ttWTree.cPredicateType          = "par"
            ttWTree.cPredicateExp           = ?

            ttWTree.cParenthesisType        = "and"
            ttWTree.lParenthesisNot         = no
            ttWTree.iPredicateCnt           = 2

            ttWTree.lLiteralValue           = ?

            ttWTree.hSimpleField            = ?
            ttWTree.iSimpleExtent           = ?
            ttWTree.cSimpleOperator         = ?

            ttWTree.hSimpleField2           = ?
            ttWTree.iSimpleExtent2          = ?
            ttWTree.cSimpleOperator2        = ?.

        assign
            piParenthesisId1                = ttWTree.iPredicateId

            bParenthesis1.iParenthesisId    = ttWTree.iPredicateId.

        run copyParenthesis(
            input ttWTree.iPredicateId,
            input bParenthesis2.iPredicateId ).

    end. /* not lAnd1 and not lAnd2 */

end procedure. /* copyParenthesisByAnd */

procedure copyParenthesis private:

    define input param piParenthesisId    as {&xSequence} no-undo. 
    define input param piPredicateId      as {&xSequence} no-undo.

    define buffer bOldWTree for ttWTree.
    define buffer bNewWTree for ttWTree.

    find first bOldWTree
         where bOldWTree.iPredicateId = piPredicateId
         use-index iPredicateId
         no-error.

    if avail bOldWTree then do:

        iPredicateIdSeq = iPredicateIdSeq + 1.

        create bNewWTree.

        buffer-copy bOldWTree to bNewWTree
            assign
                bNewWTree.iParenthesisId    = piParenthesisId
                bNewWTree.iPredicateId      = iPredicateIdSeq.

        if bNewWTree.cPredicateType = "par" then

        run copyPredicates(
            input bNewWTree.iPredicateId,
            input bOldWTree.iPredicateId ).

    end. /* avail */

end procedure. /* copyParenthesis */

procedure copyPredicates private:

    define input param pdNewParenthesisId as {&xSequence} no-undo.
    define input param pdOldParenthesisId as {&xSequence} no-undo.

    define buffer bOldWTree for ttWTree.
    define buffer bNewWTree for ttWTree.

    for each  bOldWTree
        where bOldWTree.iParenthesisId = pdOldParenthesisId
        use-index WTree:

        iPredicateIdSeq = iPredicateIdSeq + 1.

        create bNewWTree.

        buffer-copy bOldWTree to bNewWTree
            assign
                bNewWTree.iParenthesisId    = pdNewParenthesisId
                bNewWTree.iPredicateId      = iPredicateIdSeq.

        if bNewWTree.cPredicateType = "par" then

        run copyPredicates(
            input bNewWTree.iPredicateId,
            input bOldWTree.iPredicateId ).

    end. /* for each */

end procedure. /* copyPredicates */

procedure deleteParenthesis private:

    define input param piParenthesisId as {&xSequence} no-undo.

    define buffer ttWTree   for ttWTree.
    define buffer ttLiteral for ttLiteral.

    find first ttWTree
         where ttWTree.iPredicateId = piParenthesisId
         use-index iPredicateId
         no-error.

    if avail ttWTree then do:

        delete ttWTree.

        for each  ttWTree
            where ttWTree.iParenthesisId = piParenthesisId
            use-index WTree:

            if ttWTree.cPredicateType = "par" then
                run deleteParenthesis( ttWTree.iPredicateId ).

            else
            delete ttWTree.

        end. /* for each */

        for each  ttLiteral
            where ttLiteral.iParenthesisId = piParenthesisId
            use-index WTree:

            delete ttLiteral.

        end. /* for each */

    end. /* avail */

end procedure. /* deleteParenthesis */



procedure getQuery private:

    define input param  phQuery as handle no-undo.
    define param buffer pbQuery for ttQuery.

    if not valid-handle( phQuery ) or phQuery:type <> "query" then
        {err_throw "'qry_invalid_query_handle'"}.

    find first pbQuery
         where pbQuery.hQuery           = phQuery
           and pbQuery.iQueryUniqueId   = phQuery:unique-id
         use-index hQuery
         no-error.

    if not avail pbQuery then
        {err_throw "'qry_unknown_query'"}.

end procedure. /* getQuery */

procedure getBuffer private:

    define input param  phQuery  as handle no-undo.
    define input param  pcBuffer as char no-undo.
    define param buffer pbBuffer for ttBuffer.

    case num-entries( pcBuffer, "." ):

        when 1 then

        find first pbBuffer
             where pbBuffer.hQuery      = phQuery
               and pbBuffer.cBufferName = pcBuffer
             use-index QueryBufferName
             no-error.

        when 2 then

        find first pbBuffer
             where pbBuffer.hQuery      = phQuery
               and pbBuffer.cDbName     = entry( 1, pcBuffer, "." )
               and pbBuffer.cBufferName = entry( 2, pcBuffer, "." )
             use-index QueryBufferName
             no-error.

        otherwise 
        {err_throw "'qry_invalid_buffer_name'" pcBuffer}.

    end case. /* num-entries */

    if not avail pbBuffer then
        {err_throw "'qry_unknown_buffer'" pcBuffer}.

end procedure. /* getBuffer */

procedure getField private:

    define input    param phQuery   as handle no-undo.
    define input    param pcField   as char no-undo.
    define output   param phField   as handle no-undo.
    define output   param piExtent  as int no-undo.

    define var cExtent          as char no-undo.
    define var cField           as char no-undo.
    define var cFieldName       as char no-undo.
    define var cFieldBuffer     as char no-undo.
    define var cFieldDatabase   as char no-undo.

    define var hndl             as handle no-undo.
    define var i                as int no-undo.

    assign
        pcField     = trim( pcField )
        phField     = ?
        piExtent    = ?

    i = index( pcField, "[" ). if i > 0 then

    assign
        cExtent =             substr( pcField, i )
        cField  = right-trim( substr( pcField, 1, i - 1 ) ).

    else

    assign
        cExtent = ""
        cField  = pcField.



    case num-entries( cField, "." ):

        when 1 then do:

            assign
                cFieldName = cField.

            open query qBuffer

                for each  ttBuffer
                    where ttBuffer.hQuery = phQuery
                    use-index QueryBufferName.

        end. /* num-entries = 1 */

        when 2 then do:

            assign
                cFieldBuffer    = entry( 1, cField, "." )
                cFieldName      = entry( 2, cField, "." ).

            open query qBuffer

                for each  ttBuffer
                    where ttBuffer.hQuery       = phQuery
                      and ttBuffer.cBufferName  = cFieldBuffer
                    use-index QueryBufferName.

        end. /* num-entries = 2 */

        when 3 then do:

            assign
                cFieldDatabase  = entry( 1, cField, "." )
                cFieldBuffer    = entry( 2, cField, "." )
                cFieldName      = entry( 3, cField, "." ).

            open query qBuffer

                for each  ttBuffer
                    where ttBuffer.hQuery       = phQuery
                      and ttBuffer.cBufferName  = cFieldBuffer
                      and ttBuffer.cDbName      = cFieldDatabase
                    use-index QueryBufferName.

        end. /* num-entries = 3 */

        otherwise 
        {err_throw "'qry_invalid_field_name'" pcField}.

    end case. /* num-entries */

    repeat while query qBuffer:get-next( ):

        hndl = ttBuffer.hBuffer:buffer-field( cFieldName ) no-error. 

        if hndl <> ? then do:

            if phField <> ? then
                {err_throw "'qry_ambiguous_field'" pcField}.

            phField = hndl.

        end. /* hndl <> ? */

    end. /* repeat */

    if phField = ? then 
        {err_throw "'qry_unknown_field'" pcField}.



    if cExtent <> "" then do:

        i = length( cExtent ).

        if substr( cExtent, i ) <> "]" then
            {err_throw "'qry_invalid_field_name'" pcField}.

        piExtent = int( trim( substr( cExtent, 2, i - 2 ) ) ) no-error.

        if piExtent = ? then
            {err_throw "'qry_invalid_extent_value'" cExtent}.

        if piExtent < 1 then
            {err_throw "'qry_extent_le_zero'" cExtent}.

    end. /* cExtent <> "" */

end procedure. /* getField */



function breakStatement returns char private

    ( pcStatement   as char,
      pcPhraseList  as char,
      pcExcludeList as char ):

    define var cPhrase          as char no-undo.
    define var iPhrase          as int no-undo.
    define var cPhraseContent   as char no-undo.
    define var iPhraseStart     as int no-undo.
    define var iPhraseEnd       as int no-undo.

    define var cNext            as char no-undo.
    define var iNext            as int no-undo.
    define var iNextStart       as int no-undo.
    define var iNextEnd         as int no-undo.

    define var cExcludeList     as char no-undo.
    define var iOpenBracket     as int no-undo.
    define var iOpenExtent      as int no-undo.
    define var lWordSep         as log no-undo.

    define var retval           as char no-undo.
    define var iLen             as int no-undo.
    define var iPos             as int no-undo.
    define var ch               as char no-undo.

    assign
        cPhrase         = ""
        iPhrase         = 0
        iPhraseStart    = 1
        iPhraseEnd      = iPhraseStart

        cExcludeList    = ""
        iOpenBracket    = 0
        iOpenExtent     = 0
        lWordSep        = yes

        retval          = ""
        iLen            = length( pcStatement )
        iPos            = 1.

    repeat while iPos <= iLen:

        assign
            cNext       = ""
            iNext       = 0
            iNextStart  = iLen + 1
            iNextEnd    = iNextStart.

        repeat while iPos <= iLen:

            ch = substr( pcStatement, iPos, 1 ).

            if ch = '"' or ch = "'" then do:

                define var cQuote as char no-undo.

                assign
                    lWordSep    = yes
                    cQuote      = ch
                    iPos        = iPos + 1.

                repeat while iPos <= iLen:

                    ch = substr( pcStatement, iPos, 1 ).

                    if ch = cQuote then do:

                        if substr( pcStatement, iPos + 1, 1 ) = cQuote then

                            iPos = iPos + 2.

                        else do:

                            iPos = iPos + 1.

                            leave.

                        end. /* else */

                    end. /* ch = cQuote */

                    else
                    if ch = "~~" or ch = "~\" and opsys = "unix" then do:

                        ch = substr( pcStatement, iPos + 1, 1 ).

                        /* to parse the quotation only quotes and special character signs are escaped. */

                        if ch = '"' or ch = "'" or ch = "~~" or ch = "~\" then
                             iPos = iPos + 2.
                        else iPos = iPos + 1.

                    end. /* "~" */

                    else
                    iPos = iPos + 1.

                end. /* repeat */

                if iPos > iLen then
                    {err_throw "'qry_unmatched_quote'"}.

            end. /* '"' */



            else
            if ch = "~~" or ch = "~\" and opsys = "unix" then do:

                ch = substr( pcStatement, iPos + 1, 1 ).

                if ch = '"' or ch = "'" then 
                assign 
                    lWordSep    = yes
                    iPos        = iPos + 2.

                if ch = "~~" or ch = "~\" then 
                assign 
                    lWordSep    = no
                    iPos        = iPos + 2.

                else
                assign
                    iPos        = iPos + 1.

            end. /* "~" */



            else
            if  ch >= "a" and ch <= "z" and lWordSep

            and iOpenBracket = 0 and iOpenExtent = 0 then do:

                define var str  as char no-undo.
                define var i    as int no-undo.
                define var j    as int no-undo.

                assign
                    i           = iPos

                    lWordSep    = no
                    iPos        = iPos + 1.

                repeat while iPos <= iLen:

                    ch = substr( pcStatement, iPos, 1 ).

                    if not ( ch >= "a" and ch <= "z"
                          or ch >= "0" and ch <= "9"
                          or ch = "_" or ch = "-" or ch = "." ) then

                        leave.

                    iPos = iPos + 1.

                end. /* repeat */

                assign
                    str = substr( pcStatement, i, iPos - i )
                    j   = lookup( str, pcPhraseList, "|" ).

                if  j > 0 and lookup( str, cExcludeList, "+" ) = 0 then do:

                    assign
                        cNext       = str
                        iNext       = j
                        iNextStart  = i
                        iNextEnd    = iPos.

                    leave.

                end. /* lookup > 0 */

            end. /* "a".."z" */

            else
            if ch = "," and iOpenBracket = 0 and iOpenExtent = 0 then do:

                assign
                    i           = iPos
                    j           = lookup( ",", pcPhraseList, "|" )

                    lWordSep    = yes
                    iPos         = iPos + 1.

                if j > 0 then do:

                    assign
                        cNext       = ","
                        iNext       = j
                        iNextStart  = i
                        iNextEnd    = iPos.

                    leave.

                end. /* j > 0 */

            end. /* "," */



            else do:

                if ch = "(" or ch = ")"
                or ch = "[" or ch = "]" then do:

                    case ch:

                        when "(" then iOpenBracket = iOpenBracket + 1.
                        when ")" then iOpenBracket = iOpenBracket - 1.
                        when "[" then iOpenExtent = iOpenExtent + 1.
                        when "]" then iOpenExtent = iOpenExtent - 1.

                    end case. /* ch */

                    /* note that the function cannot catch improperly nested brackets and square
                       brackets which would require an actual and much more complicated parsing.
                       though the error will be picked up when the query is prepared. */

                    if iOpenBracket < 0 then {err_throw "'qry_closing_bracket_not_expected'"}.
                    if iOpenExtent  < 0 then {err_throw "'qry_closing_square_bracket_not_expected'"}.

                    assign
                        lWordSep    = yes
                        iPos        = iPos + 1.

                end. /* "(", ")", "[", "]" */

                else do:

                    assign
                        lWordSep    = ( index( {&xWordSep}, ch ) > 0 )
                        iPos        = iPos + 1.

                end. /* else */

            end. /* else */

        end. /* repeat */



        cPhraseContent = trim( substr( pcStatement, iPhraseEnd, iNextStart - iPhraseEnd ) ).

        if cPhrase <> "" or cPhraseContent <> "" then

            retval = retval 

                + ( if retval <> "" then chr(1) else "" )
                + cPhrase + chr(2) + cPhraseContent.

        if cNext = "," then /* regradless if a phrase was added or not. */

            retval = retval + chr(3).



        if cNext <> "," then

        assign
            cPhrase         = cNext
            iPhrase         = iNext
            iPhraseStart    = iNextStart
            iPhraseEnd      = iNextEnd

            cExcludeList    = entry( iPhrase, pcExcludeList, "|" ).

        else

        assign
            cPhrase         = ""
            iPhrase         = 0
            iPhraseStart    = iNextEnd
            iPhraseEnd      = iPhraseStart

            cExcludeList    = "".

    end. /* repeat */

    if iOpenBracket > 0 then {err_throw "'qry_unclosed_bracket'"}.
    if iOpenExtent  > 0 then {err_throw "'qry_unclosed_square_bracket'"}.

    return retval.

end function. /* breakStatement */

function trimSource returns char private

    ( pcSource as char ):

    /* this function was designed for trimming dynamic queries prepare-string and specifically 
       should not be used with preprocessors. because the procedure reads new lines as spaces 
       that in some preprocessor directives also act as an end of statement. */

    define var retval   as char no-undo.
    define var iLen     as int no-undo.
    define var iPos     as int no-undo.
    define var ch       as char no-undo.

    assign
        pcSource    = replaceNnn( pcSource )

        retval      = ""
        iLen        = length( pcSource )
        iPos        = 1.

    repeat while iPos <= iLen:

        ch = substr( pcSource, iPos, 1 ).

        if ch = "/" and substr( pcSource, iPos + 1, 1 ) = "*" then do:

            define var iOpenCmt as int no-undo.

            assign
                iOpenCmt    = 1
                iPos        = iPos + 2.

            repeat while iOpenCmt > 0 and iPos <= iLen:

                ch = substr( pcSource, iPos, 2 ).

                if ch = "/*" then
                assign
                     iOpenCmt   = iOpenCmt + 1
                     iPos       = iPos + 2.

                else

                if ch = "*/" then
                assign
                     iOpenCmt   = iOpenCmt - 1
                     iPos       = iPos + 2.

                else iPos       = iPos + 1.

            end. /* repeat */

        end. /* "/" */



        else
        if ch = '"' or ch = "'" then do:

            define var cQuote as char no-undo.

            assign
                cQuote  = ch
                retval  = retval + ch
                iPos    = iPos + 1.

            repeat while iPos <= iLen:

                ch = substr( pcSource, iPos, 1 ).

                if ch = cQuote then do:

                    if substr( pcSource, iPos + 1, 1 ) = cQuote then

                        assign
                            retval  = retval + substr( pcSource, iPos, 2 )
                            iPos    = iPos + 2.

                    else do:

                        assign
                            retval  = retval + ch
                            iPos    = iPos + 1.

                        leave.

                    end. /* else */

                end. /* ch = cQuote */

                else
                if ch = "~~" or ch = "~\" and opsys = "unix" then do:

                    assign
                        retval  = retval + substr( pcSource, iPos, 2 )
                        iPos    = iPos + 2.

                end. /* "~" */

                else do:

                    assign
                        retval  = retval + ch
                        iPos    = iPos + 1.

                end. /* else */

            end. /* repeat */

        end. /* '"' */



        else
        if ch = "~~" or ch = "~\" and opsys = "unix" then do:

            assign
                retval  = retval + substr( pcSource, iPos, 2 )
                iPos    = iPos + 2.

        end. /* "~" */



        else do:

            if ch = chr(13) or ch = chr(10) then
               ch = " ".

            if not ( ch = " "
               and ( retval = "" or substr( retval, length( retval ), 1 ) = " " ) ) then

               retval = retval + ch.

            iPos = iPos + 1.

        end. /* else */

    end. /* repeat */



    if  retval <> ""
    and substr( retval, length( retval ), 1 ) = " " then
        substr( retval, length( retval ), 1 ) = "".

    return retval.

end function. /* trimSource */

function replaceNnn returns char private

    ( pcSource as char ):

    define var n as char no-undo.
    define var i as int no-undo.
    define var j as int no-undo.

    j = index( pcSource, "~~" ).

    repeat while j <> 0:

        _Nnn:

        do:

            n = substr( pcSource, j + 1, 1 ). if not ( n >= "0" and n <= "3" ) then leave _Nnn.
            i =     int(n) * 64.

            n = substr( pcSource, j + 2, 1 ). if not ( n >= "0" and n <= "9" ) then leave _Nnn.
            i = i + int(n) * 8.

            n = substr( pcSource, j + 3, 1 ). if not ( n >= "0" and n <= "9" ) then leave _Nnn.
            i = i + int(n).

            if i > 255 then i = i mod 256.
            if i = 000 then i = 032.

            assign
                substr( pcSource, j, 4 ) = chr(i)

                j = index( pcSource, "~~", j + 4 ).

            next.

        end. /* _Nnn */

        j = index( pcSource, "~~", j + 2 ).

    end. /* repeat */

    return pcSource.

end function. /* replaceNnn */



procedure setWhere private:

    define param buffer pbQuery     for ttQuery.
    define input param  pcBuffer    as char no-undo.
    define input param  pcWhere     as char no-undo.

    define buffer bBuffer for ttBuffer.

    if pbQuery.lPrepared then
        {err_throw "'qry_attempt_to_modify_prepared_query'"}.

    if pcWhere begins "where" and index( {&xWordSep}, substr( pcWhere, 6, 1 ) ) >= 0 then
        {err_throw "'qry_remove_where'"}.

    if pcBuffer <> ? then do:

        run getBuffer(
            input   pbQuery.hQuery,
            input   pcBuffer,
            buffer  bBuffer ).

        if bBuffer.cWhereDynamic <> "" then
            {err_throw "'qry_where_already_filled'"}.

        bBuffer.cWhereDynamic = pcWhere.

    end. /* pcBuffer <> ? */

    else do:

        if pbQuery.cWhereDynamic <> "" then
            {err_throw "'qry_where_already_filled'"}.

        pbQuery.cWhereDynamic = pcWhere.

    end. /* else */

end procedure. /* setWhere */



define temp-table ttCando no-undo

    field cEqual    as char
    field cBegins   as char
    field cMatches  as char
    field cValue    as char
    index cValue    is primary unique cValue.

procedure andCondition private:

    define param buffer pbQuery         for ttQuery.
    define input param  pcBuffer        as char no-undo.
    define input param  pcField         as char no-undo.
    define input param  pcOperator      as char no-undo.
    define input param  pcValue         as char no-undo.
    define input param  plKeepBlanks    as log no-undo.

    define buffer bBuffer for ttBuffer.

    define var cCondition   as char no-undo.
    define var lNot         as log no-undo.

    define var hField       as handle no-undo.
    define var iExtent      as int no-undo.

    define var lBlank       as log no-undo.
    define var lBlank2      as log no-undo.
    define var cValue       as char no-undo.
    define var cValue2      as char no-undo.
    define var cSensitive   as char case-sensitive no-undo.
    define var cSensitive2  as char case-sensitive no-undo.

    define var cEqual       as char no-undo.
    define var cBegins      as char no-undo.
    define var cMatches     as char no-undo.
    define var lNotCando    as log no-undo.
    define var lMatches     as log no-undo.

    define var str          as char no-undo.
    define var ch           as char no-undo.
    define var i            as int no-undo.
    define var j            as int no-undo.

    if pbQuery.lPrepared then
        {err_throw "'qry_attempt_to_modify_prepared_query'"}.

    if pcBuffer <> ? then
    run getBuffer(
        input   pbQuery.hQuery,
        input   pcBuffer,
        buffer  bBuffer ).

    run getField(
        input   pbQuery.hQuery,
        input   pcField,
        output  hField,
        output  iExtent ).

    if lookup( hField:data-type, {&xSuppDataTypes} ) = 0 then
        {err_throw "'qry_datatype_not_supported'" hField:data-type "caps( {&xSuppDataTypes} )"}.

    pcField = hField:dbname + "." + hField:buffer-name + "." + hField:name + ( if iExtent <> ? then "[" + string( iExtent ) + "]" else "" ).



    pcOperator = trim( pcOperator ).

    if pcOperator begins "not " then

    assign
       pcOperator  = left-trim( substr( pcOperator, 5 ) )
       lNot        = yes.

    case pcOperator:

        when "eq" then pcOperator = "=".
        when "gt" then pcOperator = ">".
        when "lt" then pcOperator = "<".
        when "ge" then pcOperator = ">=".
        when "le" then pcOperator = "<=".
        when "ne" then pcOperator = "<>".

    end case. /* pcOperator */

    if lookup( pcOperator, {&xSuppOperators} ) = 0 then
        {err_throw "'qry_operator_not_supported'" pcOperator {&xSuppOperators}}.



    if lookup( pcOperator, "=,<,>,<=,>=,<>,begins,contains" ) > 0 then do:

        if not ( not plKeepBlanks and isBlank( pcValue, hField:data-type ) ) then do:

            if hField:data-type <> "character" then

                cValue = checkType( hField:data-type, pcValue ).

            cCondition = ( if lNot then "not " else "" ) + pcField + " " + pcOperator + " " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

        end. /* not blank */

    end. /* lookup > 0 */



    else do:

        ch = ( if index( pcValue, chr(1) ) > 0 then chr(1) else "," ).

        if pcOperator = "between" then do:

            if num-entries( pcValue, ch ) <> 2 then
                {err_throw "'qry_invalid_between_range'"}.

            assign
                cValue  = entry( 1, pcValue, ch )
                cValue2 = entry( 2, pcValue, ch )

                lBlank  = ( not plKeepBlanks and isBlank( cValue,   hField:data-type ) )
                lBlank2 = ( not plKeepBlanks and isBlank( cValue2,  hField:data-type ) ).

            if hField:data-type <> "character" then
            assign
                cValue  = checkType( cValue,    hField:data-type ) when not lBlank
                cValue2 = checkType( cValue2,   hField:data-type ) when not lBlank2.

            if  lBlank  = no
            and lBlank2 = yes then

                cCondition = ( if lNot then "not " else "" ) + pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

            else
            if  lBlank  = yes
            and lBlank2 = no then

                cCondition = ( if lNot then "not " else "" ) + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ).

            else
            if  lBlank  = no 
            and lBlank2 = no then do:

                case hField:data-type:

                    when "logical" then do:

                        if cValue = cValue2 then
                        cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

                        else
                        if cValue = "no" and cValue2 = "yes" then /* cValue > cValue2 */
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) ).

                        else
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) ).

                    end. /* logical */

                    when "character" then do:

                        if hField:case-sensitive then do:

                            assign
                                cSensitive  = cValue
                                cSensitive2 = cValue2.

                            if cSensitive = cSensitive2 then
                            cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cSensitive, hField:data-type ).

                            else
                            if cSensitive > cSensitive2 then
                            cCondition =

                                ( if lNot then "not ( " +
                                       pcField + " >= " + insertValue( pbQuery.hQuery, cSensitive2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cSensitive, hField:data-type ) + " )"
                                  else pcField + " >= " + insertValue( pbQuery.hQuery, cSensitive2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cSensitive, hField:data-type ) ).

                            else
                            cCondition =

                                ( if lNot then "not ( " +
                                       pcField + " >= " + insertValue( pbQuery.hQuery, cSensitive, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cSensitive2, hField:data-type ) + " )"
                                  else pcField + " >= " + insertValue( pbQuery.hQuery, cSensitive, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cSensitive2, hField:data-type ) ).

                        end. /* case-sensitive */

                        else do:

                            if cValue = cValue2 then
                            cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

                            else
                            if cValue > cValue2 then
                            cCondition =

                                ( if lNot then "not ( " +
                                       pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " )"
                                  else pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) ).

                            else
                            cCondition =

                                ( if lNot then "not ( " +
                                       pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " )"
                                  else pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) ).

                        end. /* else */

                    end. /* character */

                    when "integer" then do:

                        if int( cValue ) = int( cValue2 ) then
                        cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

                        else
                        if int( cValue ) > int( cValue2 ) then
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) ).

                        else
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) ).

                    end. /* integer */

                    &if {&pro_xProversion} >= "10.1b" &then

                    when "int64" then do:

                        if int64( cValue ) = int64( cValue2 ) then
                        cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

                        else
                        if int64( cValue ) > int64( cValue2 ) then
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) ).

                        else
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) ).

                    end. /* int64 */

                    &endif /* proversion >= 10.1b */

                    when "decimal" then do:

                        if decimal( cValue ) = decimal( cValue2 ) then
                        cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

                        else
                        if decimal( cValue ) > decimal( cValue2 ) then
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) ).

                        else
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) ).

                    end. /* decimal */

                    when "date" then do:

                        if date( cValue ) = date( cValue2 ) then
                        cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

                        else
                        if date( cValue ) > date( cValue2 ) then
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) ).

                        else
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) ).

                    end. /* date */

                    &if {&pro_xProversion} >= "10" &then

                    when "datetime" then do:

                        if datetime( cValue ) = datetime( cValue2 ) then
                        cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type  ).

                        else
                        if datetime( cValue ) > datetime( cValue2 ) then
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) ).

                        else
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) ).

                    end. /* datetime */

                    when "datetime-tz" then do:

                        if datetime-tz( cValue ) = datetime-tz( cValue2 ) then
                        cCondition = ( if lNot then "not " else "" ) + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type ).

                        else
                        if datetime-tz( cValue ) > datetime-tz( cValue2 ) then
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) ).

                        else
                        cCondition =

                            ( if lNot then "not ( " +
                                   pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) + " )"
                              else pcField + " >= " + insertValue( pbQuery.hQuery, cValue, hField:data-type ) + " and " + pcField + " <= " + insertValue( pbQuery.hQuery, cValue2, hField:data-type ) ).

                    end. /* datetime-tz */

                    &endif /* proversion >= 10 */

                end case. /* data-type */

            end. /* no blanks */

        end. /* between */



        else
        if pcOperator = "in" then do:

            assign
                cCondition  = ""
                str         = ""

            j = num-entries( pcValue, ch ). do i = 1 to j:

                cValue = entry( i, pcValue, ch ).

                if not ( not plKeepBlanks and isBlank( cValue, hField:data-type ) ) then do:

                    if hField:data-type <> "character" then

                        cValue = checkType( cValue, hField:data-type ).

                    if lookup( cValue, str ) = 0 then

                    assign
                        cCondition = cCondition 

                            + ( if cCondition <> "" then " or " else "" ) 
                            + pcField + " = " + insertValue( pbQuery.hQuery, cValue, hField:data-type )

                        str = str

                            + ( if str <> "" then ch else "" )
                            + cValue.

                end. /* not blank */

            end. /* 1 to num-entries */

            j = num-entries( str, ch ). if j > 0 then do:

                if j > 1 then
                     cCondition = ( if lNot then "not " else "" ) + "( " + cCondition + " )".
                else cCondition = ( if lNot then "not " else "" ) +        cCondition.

            end. /* j > 0 */

        end. /* in */



        else
        if pcOperator = "matches" then do:

            if pcValue = ? then

                cCondition = "no". /* [not] x matches ? = no for a where clause */

            else
            if not ( not plKeepBlanks and isBlank( pcValue, hField:data-type ) ) then do:

                if lNot then

                    cCondition = "not " + pcField + " matches " + insertValue( pbQuery.hQuery, pcValue, hField:data-type ).

                else do:

                    run optimizeMatches(
                        input   pcValue,
                        output  cEqual,
                        output  cBegins,
                        output  cMatches ).

                    assign
                        cCondition = ""
                        cCondition = cCondition + ( if cCondition <> "" then " and " else "" ) + pcField + " = "        + insertValue( pbQuery.hQuery, cEqual,      hField:data-type ) when cEqual <> ?
                        cCondition = cCondition + ( if cCondition <> "" then " and " else "" ) + pcField + " begins "   + insertValue( pbQuery.hQuery, cBegins,     hField:data-type ) when cBegins <> ?
                        cCondition = cCondition + ( if cCondition <> "" then " and " else "" ) + pcField + " matchess " + insertValue( pbQuery.hQuery, cMatches,    hField:data-type ) when cMatches <> ?.

                    if cBegins <> ? and cMatches <> ? then
                         cCondition = "not ( " + cCondition + " )".
                    else cCondition = "not "   + cCondition.

                end. /* else */

            end. /* not isBlank */

        end. /* matches */



        else
        if pcOperator = "can-do" then do:

            if pcValue = ? then

                cCondition = "no". /* [not] can-do( ?, x ) = no for a where clause */

            else do:

                empty temp-table ttCando.

                assign
                    lNotCando   = no
                    lMatches    = no

                    lBlank      = yes
                    lBlank2     = yes

                j = num-entries( pcValue, ch ). do i = 1 to j:
 
                    cValue = entry( i, pcValue, ch ).

                    if not ( not plKeepBlanks and isBlank( cValue, hField:data-type ) ) then do:

                        if cValue begins "!" then
                            lNotCando = yes.

                        else
                        if not can-find(
                            first ttCando
                            where ttCando.cValue = cValue ) then do:

                            run optimizeMatches(
                                input   pcValue,
                                output  cEqual,
                                output  cBegins,
                                output  cMatches ).

                            if cMatches <> ? and cBegins = ? then
                               lMatches = yes.

                            create ttCando.
                            assign
                                ttCando.cEqual      = cEqual
                                ttCando.cBegins     = cBegins
                                ttCando.cMatches    = cMatches
                                ttCando.cValue      = cValue.

                            lBlank2 = no.

                        end. /* not can-find */

                        lBlank = no.

                    end. /* not blank */

                end. /* 1 to num-entries */

                if lBlank then

                    cCondition = "".

                else
                if lBlank2 then

                    cCondition = ( if lNot then "yes" else "no" ).

                else
                if lNot or lMatches then

                    cCondition = ( if lNot then "not " else "" ) + "can-do( " + insertValue( pbQuery.hQuery, pcValue, hField:data-type ) + ", " + pcField + " )".

                else do:

                    assign
                        cCondition  = ""
                        i           = 0.

                    for each ttCando:

                        assign
                            i           = i + 1

                            str         = ""
                            str         = str + ( if str <> "" then " and " else "" ) + pcField + " = "        + insertValue( pbQuery.hQuery, ttCando.cEqual,   hField:data-type ) when cEqual <> ?
                            str         = str + ( if str <> "" then " and " else "" ) + pcField + " begins "   + insertValue( pbQuery.hQuery, ttCando.cBegins,  hField:data-type ) when cBegins <> ?
                            str         = str + ( if str <> "" then " and " else "" ) + pcField + " matchess " + insertValue( pbQuery.hQuery, ttCando.cMatches, hField:data-type ) when cMatches <> ?

                            cCondition  = cCondition

                                + ( if cCondition <> "" then " or " else "" )
                                + str.

                    end. /* for each */

                    if i > 1 then
                         cCondition = "( " + cCondition + " )" + ( if lNotCando then " and can-do( " + insertValue( pbQuery.hQuery, pcValue, hField:data-type ) + ", " + pcField + " )" else "" ).
                    else cCondition =        cCondition        + ( if lNotCando then " and can-do( " + insertValue( pbQuery.hQuery, pcValue, hField:data-type ) + ", " + pcField + " )" else "" ).

                end. /* else */

            end. /* else */

        end. /* can-do */

    end. /* else */



    if cCondition <> "" then do:

        if cBuffer <> ? then

             bBuffer.cWhereDynamic = bBuffer.cWhereDynamic

                + ( if bBuffer.cWhereDynamic <> "" then " and " else "" )
                + cCondition.

        else pbQuery.cWhereDynamic = pbQuery.cWhereDynamic

                + ( if pbQuery.cWhereDynamic <> "" then " and " else "" )
                + cCondition.

    end. /* cCondition <> "" */

end procedure. /* andCondition */

procedure andExpression private:

    define param buffer pbQuery         for ttQuery.
    define input param  pcBuffer        as char no-undo.
    define input param  pcExpression    as char no-undo.

    define buffer bBuffer for ttBuffer.

    if pbQuery.lPrepared then
        {err_throw "'qry_attempt_to_modify_prepared_query'"}.

    pcExpression = trim( pcExpression ).

    if pcBuffer <> ? then do:

        run getBuffer(
            input   pbQuery.hQuery,
            input   pcBuffer,
            buffer  bBuffer ).

        bBuffer.cWhereDynamic = bBuffer.cWhereDynamic

            + ( if bBuffer.cWhereDynamic <> "" then " and " else "" )
            + "(" + pcExpression + ")".

    end. /* pcBuffer <> ? */

    else

    pbQuery.cWhereDynamic = pbQuery.cWhereDynamic

        + ( if pbQuery.cWhereDynamic <> "" then " and " else "" )
        + "(" + pcExpression + ")".

end procedure. /* andExpression */

procedure optimizeMatches:

    define input    param pcValue   as char no-undo.
    define output   param pcEqual   as char no-undo.
    define output   param pcBegins  as char no-undo.
    define output   param pcMatches as char no-undo.

    define var iLen as int no-undo.
    define var iPos as int no-undo.

    define var str  as char no-undo.
    define var ch   as char no-undo case-sensitive.
    define var i    as int no-undo.

    assign
        iLen = length( pcValue )
        iPos = 1.

    repeat while iPos <= iLen:

        ch = substr( pcValue, iPos, 1 ).

        if ch = "*" or ch = "." then

            leave.

        else

        if ch = "~~" or ch = "~\" and opsys = "unix" then do:

            ch = substr( pcValue, iPos + 1, 1 ). if ch >= "0" and ch <= "3" then do:

                i = int( ch ) * 64.

                ch  = substr( pcValue, iPos + 2, 1 ). if ch >= "0" and ch <= "9" then do:

                    i = i + int( ch ) * 8.

                    ch  = substr( pcValue, iPos + 3, 1 ). if ch >= "0" and ch <= "9" then do:

                        i = i + int( ch ).

                        if i > 255 then i = i mod 256.
                        if i = 000 then i = 032.

                        assign
                            str     = str + chr(i)
                            iPos    = iPos + 4.

                    end. /* 0..9 */

                    else

                    assign
                        str     = substr( pcValue, iPos + 1, 2 )
                        iPos    = iPos + 3.

                end. /* 0..9 */

                else

                assign
                    str     = substr( pcValue, iPos + 1, 1 )
                    iPos    = iPos + 2.

            end. /* 0..3 */

            else do:

                case ch: /* case-sensitive */

                    when "t" then ch = "~t".
                    when "r" then ch = "~r".
                    when "n" then ch = "~n".
                    when "E" then ch = "~E".
                    when "b" then ch = "~b".
                    when "f" then ch = "~f".

                end case. /* ch */

                assign
                    str     = str + ch
                    iPos    = iPos + 2.

            end. /* else */

        end. /* ch = "~~" */

        else

        assign
            str     = str + ch
            iPos    = iPos + 1.

    end. /* repeat */



    if iPos = 1 then

    assign
        pcEqual     = ?
        pcBegins    = ?
        pcMatches   = pcValue.

    else
    if iPos > iLen then

    assign
        pcEqual     = str
        pcBegins    = ?
        pcMatches   = ?.

    else
    if ch = "*" and ( iPos = iLen or /* redundant ~ at the end of the string */ iPos = iLen - 1 and ( substr( pcValue, iLen, 1 ) = "~~" or substr( pcValue, iLen, 1 ) = "~\" and opsys = "unix" ) ) then

    assign
        pcEqual     = ?
        pcBegins    = str
        pcMatches   = ?.

    else

    assign
        pcEqual     = ?
        pcBegins    = str
        pcMatches   = pcValue.

end procedure. /* optimizeMatches */



function insertSafeValue returns char private ( phQuery as handle, pcValue as char, pcDataType as char ):

    pcDataType = unabbrType( pcDataType ).

    if lookup( pcDataType, {&xSuppDataTypes} ) = 0 then

        {err_throw "'qry_datatype_not_supported'" "caps( pcDataType )" "caps( {&xSuppDataTypes} )"}.

    if pcDataType <> "character" then

        pcValue = checkType( pcValue, pcDataType ).

    return insertValue( phQuery, pcValue, pcDataType ).

end function. /* insertSafeValue */

function insertValue returns char private ( phQuery as handle, pcValue as char, pcDataType as char ):

    case pcDataType:

        when "character" then
        return insertParam( phQuery, pcValue ).

        /* note that literal date format in query-prepare is set by the sessions date-format unlike compiled procedures which are always mdy and doesnt require any intervention */

        &if {&pro_xProversion} >= "10" &then

        when "datetime" then
        return 'datetime( "' + pcValue + '" )'.

        when "datetime-tz" then 
        return 'datetime-tz( "' + pcValue + '" )'.

        &endif /* proversion >= 10 */

        otherwise
        return pcValue.

    end case. /* pcDataType */

end function. /* insertValue */

function insertParam returns char private ( phQuery as handle, pcValue as char ):

    define buffer ttParam for ttParam.

    iParamIdSeq = iParamIdSeq + 1.

    create ttParam.
    assign
        ttParam.hQuery      = phQuery
        ttParam.iParamId    = iParamIdSeq
        ttParam.cValue      = pcValue.

    return 'dynamic-function( "qry_getParam", ' + string( ttParam.iParamId ) + ' )'.

end function. /* insertParam */

function unabbrType returns char private ( pcDataType as char ):

    pcDataType = trim( pcDataType ).

    if  pcDataType  begins "l"
    and "logical"   begins pcDataType then

        pcDataType = "logical".

    else
    if  pcDataType  begins "c"
    and "character" begins pcDataType then

        pcDataType = "character".

    else
    if  pcDataType  begins "i"
    and "integer"   begins pcDataType then

        pcDataType = "integer".

    &if {&pro_xProversion} >= "10.1b" &then

    else
    if pcDataType = "int64" then
       pcDataType = "int64".

    &endif /* proversion >= 10.1b */

    else
    if  pcDataType  begins "de"
    and "decimal"   begins pcDataType then

        pcDataType = "decimal".

    else
    if  pcDataType  begins "da"
    and "date"      begins pcDataType then

        pcDataType = "date".

    &if {&pro_xProversion} >= "10" &then

    else
    if pcDataType = "datetime" then
       pcDataType = "datetime".

    else
    if pcDataType = "datetime-tz" then
       pcDataType = "datetime-tz".

    &endif /* proversion >= 10 */

    return pcDataType.

end function. /* unabbrType */

function checkType returns char private ( pcValue as char, pcDataType as char ):

    if pcValue = "?" or pcValue = ? then
       pcValue = "?".

    else

    case pcDataType:

        when "logical" then do:

            case trim( pcValue ):

                   when "true"
                or when "yes"
                or when "y" then pcValue = "yes".

                   when "false"
                or when "no"
                or when "n" then pcValue = "no".

                otherwise
                {err_throw "'qry_type_check_failed'" "caps( pcDataType )" pcValue}.

            end case.

        end. /* integer */



        when "integer" then do:

            pcValue = string( int( pcValue ) ) no-error.

            if error-status:error then
                {err_throw "'qry_type_check_failed'" "caps( pcDataType )" pcValue}.

        end. /* integer */

        &if {&pro_xProversion} >= "10.1b" &then 

        when "int64" then do:

            pcValue = string( int64( pcValue ) ) no-error.

            if error-status:error then
                {err_throw "'qry_type_check_failed'" "caps( pcDataType )" pcValue}.

        end. /* int64 */

        &endif /* proversion >= 10.1b */

        when "decimal" then do:

            pcValue = string( dec( pcValue ) ) no-error.

            if error-status:error then
                {err_throw "'qry_type_check_failed'" "caps( pcDataType )" pcValue}.

        end. /* decimal */



        /* unlike integer( ) the date( ), datetime( ), datetime-tz( ) return ? not error for invalid values */

        when "date" then do:

            assign
               pcValue = ?
               pcValue = string( date( pcValue ) ) {err_no-error}.

            if pcValue = ? then
                {err_throw "'qry_type_check_failed'" "caps( pcDataType )" pcValue}.

        end. /* date */

        &if {&pro_xProversion} >= "10" &then

        when "datetime" then do:

            assign
               pcValue = ?
               pcValue = string( datetime( pcValue ) ) {err_no-error}.

            if pcValue = ? then
                {err_throw "'qry_type_check_failed'" "caps( pcDataType )" pcValue}.

        end. /* datetime */

        when "datetime-tz" then do:

            assign
               pcValue = ?
               pcValue = string( datetime-tz( pcValue ) ) {err_no-error}.

            if pcValue = ? then
                {err_throw "'qry_type_check_failed'" "caps( pcDataType )" pcValue}.

        end. /* datetime-tz */

        &endif /* proversion >= 10 */

    end case. /* pcDataType */

    return pcValue.

end function. /* checkType */

function isBlank returns log private ( pcValue as char, pcDataType as char ):

    define var x as dec no-undo.

    case pcDataType:

           when "logical"
        or when "character" then do:

            if pcValue = "" then
                 return yes.
            else return no.

        end. /* logical */



           when "integer" 
        or when "decimal" 

        &if {&pro_xProversion} >= "10.1b" &then 

        or when "int64"

        &endif

            then do:

            if pcValue = "" then
                return yes.

            assign
               x = ?
               x = dec( pcValue ) no-error.

            if x = 0 then
                 return yes.
            else return no.

        end. /* integer */



           when "date"

        &if {&pro_xProversion} >= "10" &then

        or when "datetime"
        or when "datetime-tz"

        &endif /* proversion >= 10 */

            then do:

            if pcValue = ""
            or pcValue = ? then
                 return yes.

            if replace( replace( replace( replace( replace( replace( pcValue, 
                "/", "" ),
                "\", "" ),
                ":", "" ),
                ".", "" ),
                "+", "" ),
                "-", "" ) = "" then

                 return yes.
            else return no.

        end. /* date */

    end case. /* pcDataType */

end function. /* isBlank */
