&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE VAR hBrowseBuffer AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getData Procedure 
PROCEDURE getData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER cDatabase AS CHAR.
DEFINE INPUT PARAMETER cTable AS CHAR.
DEFINE INPUT PARAMETER cWhere AS CHAR.
DEFINE INPUT PARAMETER cSort AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER hQuery AS HANDLE.
DEFINE OUTPUT PARAMETER iTotalRegistros AS INT.
DEFINE OUTPUT PARAMETER cMsgError AS CHAR.

DEFINE VAR cQuery AS CHAR.
DEFINE VAR hQueryTT AS HANDLE.
DEFINE VAR hBufferTable AS HANDLE.
DEFINE VAR lPrepare AS LOG.

define variable iMaxQueryTime   as integer     no-undo.
define variable iNumRecords     as integer     no-undo.
define variable iStartTime      as integer     no-undo.
define variable iQueryTime      as integer     no-undo.
define variable lCountComplete  as logical     no-undo.
define variable cAndWhere    as character   no-undo.

iTotalRegistros = 0.
cMsgError = "".

hQuery = ?.

/* SELECT */
cQuery = substitute("for each &1.&2 no-lock", cDatabase, cTable).

CREATE BUFFER hBufferTable FOR TABLE cTable.
    
CREATE QUERY hQueryTT.
hQueryTT:SET-BUFFERS(hBufferTable).

cQuery = REPLACE(cQuery,SUBSTITUTE("&1._lock",cDatabase),cTable).

/* Add the where  */
if cWhere <> '' THEN cQuery = substitute("&1 WHERE (&2)", cQuery, cWhere).

/* Add sort */
if cSort <> '' then
cQuery = substitute("&1 &2", cQuery, cSort).

/* For speed of repositioning... */
cQuery = substitute("&1 INDEXED-REPOSITION", cQuery).
/*
DEFINE VARIABLE h  AS HANDLE  NO-UNDO.
DEFINE VARIABLE qString AS CHARACTER   NO-UNDO.

CREATE QUERY h.

qString = "FOR EACH customer NO-LOCK, 
               FIRST order OF customer NO-LOCK 
               WHERE customer.custnum = order.custnum BY customer.custnum DESC".

h:SET-BUFFERS(BUFFER customer:HANDLE, BUFFER order:HANDLE). 
h:QUERY-PREPARE(qString).
h:QUERY-OPEN.

REPEAT WITH FRAME y:
  h:GET-NEXT().
  IF h:QUERY-OFF-END THEN LEAVE.
END.

h:QUERY-CLOSE().
DELETE OBJECT h.
*/

/*
/**/
if lookup(entry(1,cWhere,' '),'AND,OR,WHERE') > 0 THEN entry(1,cWhere,' ') = ''.

/* Extract the sort-by part */
if index(cWhere, 'BY ') > 0 THEN 
    assign cSort  = substring(cWhere,index(cWhere, 'BY '))
    cWhere = replace(cWhere,cSort,'').

/* Add query filter */
if cFilter <> '' THEN cQuery = substitute("&1 WHERE (&2)", cQuery, cFilter).

/* Add the where  */
if cFilter =  '' and cWhere <> '' and not cWhere begins 'BY ' then cAndWhere = 'WHERE'.
if cFilter <> '' and cWhere <> '' and not cWhere begins 'BY ' then cAndWhere = 'AND'.
if cWhere <> '' then
cQuery = substitute("&1 &2 (&3)", cQuery, cAndWhere, cWhere).

/* Add sort */
if cSort <> '' then
cQuery = substitute("&1 &2", cQuery, cSort).

/* For speed of repositioning... */
cQuery = substitute("&1 INDEXED-REPOSITION", cQuery).

*/

/**/
lPrepare = hQueryTT:QUERY-PREPARE(cQuery) NO-ERROR.
IF NOT lPrepare THEN DO:
    cMsgError = ERROR-STATUS:GET-MESSAGE(1) .
    RETURN "ADM-ERROR".
END.

hQueryTT:QUERY-OPEN().

/* Cuantos registros recupero y tiempo */
/*
iStartTime = etime.
hQueryTT:get-first.
/*do while etime - iStartTime < iMaxQueryTime and not hQueryTT:query-off-end:*/
do while not hQueryTT:query-off-end:
    hQueryTT:get-next.
    iNumRecords = iNumRecords + 1.
end.
lCountComplete = hQueryTT:query-off-end.
iQueryTime = etime - iStartTime.

iTotalRegistros = iNumRecords.
*/
hQueryTT:GET-FIRST.

hQuery = hQueryTT.

iTotalRegistros = 1.

/*hQueryTT:QUERY-CLOSE().*/

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

