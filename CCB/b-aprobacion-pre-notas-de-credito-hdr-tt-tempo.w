&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttCcbCDocu NO-UNDO LIKE CcbCDocu.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File:  

  Description: from BROWSER.W - Basic SmartBrowser Object Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-user-id AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VAR x-coddoc AS  CHAR    INIT "PNC".
DEFINE VAR x-estados AS  CHAR    INIT "T,D".      /* T:xAprobar D:Aprob.Parcial */

DEFINE VAR x-col-moneda AS CHAR.
DEFINE VAR x-col-estado AS CHAR.

DEFINE TEMP-TABLE ttLineasAutorizadas
    FIELD   tlinea  AS  CHAR.

/* Pruebas */
IF USERID("DICTDB") = "MASTER" THEN s-user-id = "ADMIN".

/*
&SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.ccbcdocu.CodCia = s-codcia AND ~
            INTEGRAL.ccbcdocu.CodDoc = x-coddoc AND ~
            INTEGRAL.ccbcdocu.codcta = '00003' AND ~
            INTEGRAL.ccbcdocu.tpofac = 'OTROS' AND ~
            LOOKUP(INTEGRAL.ccbcdocu.flgest, x-estados) > 0)
*/

&SCOPED-DEFINE CONDICION ( ~
            INTEGRAL.ccbcdocu.CodCia = s-codcia AND ~
            INTEGRAL.ccbcdocu.CodDoc = x-coddoc AND ~
            INTEGRAL.ccbcdocu.tpofac = 'OTROS' AND ~
            LOOKUP(INTEGRAL.ccbcdocu.flgest, x-estados) > 0)


/* Lineas asignadas a el usuario */
/*IF s-user-id <> 'ADMIN' THEN DO:*/
    FOR EACH vtatabla WHERE vtatabla.codcia = s-codcia AND
                                vtatabla.tabla = 'LP' AND 
                                vtatabla.llave_c1 = s-user-id NO-LOCK:
        CREATE ttLineasAutorizadas.
            ASSIGN ttLineasAutorizadas.tlinea = vtatabla.llave_c2.
    END.
/*END.*/
/*
        CREATE ttLineasAutorizadas.
            ASSIGN ttLineasAutorizadas.tlinea = "010".

*/

DEF SHARED VAR lh_handle AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME BROWSE-2

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES GN-DIVI
&Scoped-define FIRST-EXTERNAL-TABLE GN-DIVI


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR GN-DIVI.
/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttCcbCDocu CcbCDocu

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ttCcbCDocu.CodDoc ttCcbCDocu.NroDoc ~
fEstado(ttCcbCDocu.FlgEst) @ x-col-estado ttCcbCDocu.FchDoc ~
ttCcbCDocu.CodCli ttCcbCDocu.NomCli ~
if ( ttCcbCDocu.CodMon = 2 ) then 'US$' else 'S/' @ x-col-moneda ~
ttCcbCDocu.ImpTot ttCcbCDocu.Libre_c01 ttCcbCDocu.CodRef ttCcbCDocu.NroRef ~
ttCcbCDocu.usuario 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ttCcbCDocu OF GN-DIVI NO-LOCK, ~
      FIRST CcbCDocu OF ttCcbCDocu NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ttCcbCDocu OF GN-DIVI NO-LOCK, ~
      FIRST CcbCDocu OF ttCcbCDocu NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ttCcbCDocu CcbCDocu
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ttCcbCDocu
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 CcbCDocu


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS> 
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE> 
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
      ttCcbCDocu, 
      CcbCDocu SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 B-table-Win _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ttCcbCDocu.CodDoc COLUMN-LABEL "T.Doc" FORMAT "x(5)":U WIDTH 4
      ttCcbCDocu.NroDoc FORMAT "X(12)":U WIDTH 9.43
      fEstado(ttCcbCDocu.FlgEst) @ x-col-estado COLUMN-LABEL "Estado" FORMAT "x(15)":U
            WIDTH 20.43
      ttCcbCDocu.FchDoc COLUMN-LABEL "Emision" FORMAT "99/99/9999":U
            WIDTH 8.43
      ttCcbCDocu.CodCli FORMAT "x(11)":U WIDTH 10.43
      ttCcbCDocu.NomCli FORMAT "x(50)":U WIDTH 36.43
      if ( ttCcbCDocu.CodMon = 2 ) then 'US$' else 'S/' @ x-col-moneda COLUMN-LABEL "Mnd" FORMAT "x(10)":U
      ttCcbCDocu.ImpTot FORMAT "->>,>>>,>>9.99":U WIDTH 10.43
      ttCcbCDocu.Libre_c01 COLUMN-LABEL "Lineas" FORMAT "x(25)":U
      ttCcbCDocu.CodRef COLUMN-LABEL "Cod!Ref" FORMAT "x(3)":U
      ttCcbCDocu.NroRef COLUMN-LABEL "Nro!Ref" FORMAT "X(12)":U
      ttCcbCDocu.usuario COLUMN-LABEL "Usuario" FORMAT "x(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 117.57 BY 6.5
         FONT 4
         TITLE "Seleccione LA PRE-NOTA" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     BROWSE-2 AT ROW 1.04 COL 1 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   External Tables: INTEGRAL.GN-DIVI
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: ttCcbCDocu T "?" NO-UNDO INTEGRAL CcbCDocu
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 6.69
         WIDTH              = 118.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm-vm/method/vmviewer.i}
{src/adm-vm/method/vmbrowser.i}
{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB BROWSE-2 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.ttCcbCDocu OF INTEGRAL.GN-DIVI,INTEGRAL.CcbCDocu OF Temp-Tables.ttCcbCDocu"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > Temp-Tables.ttCcbCDocu.CodDoc
"ttCcbCDocu.CodDoc" "T.Doc" "x(5)" "character" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttCcbCDocu.NroDoc
"ttCcbCDocu.NroDoc" ? ? "character" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"fEstado(ttCcbCDocu.FlgEst) @ x-col-estado" "Estado" "x(15)" ? ? ? ? ? ? ? no ? no no "20.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttCcbCDocu.FchDoc
"ttCcbCDocu.FchDoc" "Emision" ? "date" ? ? ? ? ? ? no ? no no "8.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttCcbCDocu.CodCli
"ttCcbCDocu.CodCli" ? ? "character" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttCcbCDocu.NomCli
"ttCcbCDocu.NomCli" ? ? "character" ? ? ? ? ? ? no ? no no "36.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"if ( ttCcbCDocu.CodMon = 2 ) then 'US$' else 'S/' @ x-col-moneda" "Mnd" "x(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttCcbCDocu.ImpTot
"ttCcbCDocu.ImpTot" ? ? "decimal" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttCcbCDocu.Libre_c01
"ttCcbCDocu.Libre_c01" "Lineas" "x(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ttCcbCDocu.CodRef
"ttCcbCDocu.CodRef" "Cod!Ref" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ttCcbCDocu.NroRef
"ttCcbCDocu.NroRef" "Nro!Ref" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ttCcbCDocu.usuario
"ttCcbCDocu.usuario" "Usuario" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 B-table-Win
ON VALUE-CHANGED OF BROWSE-2 IN FRAME F-Main /* Seleccione LA PRE-NOTA */
DO:

    DEFINE VAR x-coddoc AS CHAR.
    DEFINE VAR x-nrodoc AS CHAR.

  IF AVAILABLE ttccbcdocu THEN DO:
      FIND FIRST ccbcdocu OF ttccbcdocu NO-LOCK NO-ERROR.

      x-coddoc = ttccbcdocu.coddoc.
      x-nrodoc = ttccbcdocu.nrodoc.
  END.
    /*
  RUN refrescar-notas-creditos IN lh_Handle (INPUT x-coddoc, INPUT x-nrodoc).
      */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */
/*
ON FIND OF ttccbcdocu DO:

    /*IF s-user-id <> 'ADMIN' THEN DO:*/
        DEFINE VAR x-lineas-del-docmto AS CHAR.
        DEFINE VAR x-lineas-trabajadas AS CHAR.
        DEFINE VAR x-registro-valido AS LOG.

        x-registro-valido = NO.
        x-lineas-del-docmto = TRIM(ttccbcdocu.libre_c01).     /* Lineas del documento */
        x-lineas-trabajadas = TRIM(ttccbcdocu.libre_c02).     /* Lineas trabajadas x el jefe de linea */

        VALIDA-LINEA:
        FOR EACH ttLineasAutorizadas NO-LOCK:
            IF LOOKUP(ttLineasAutorizadas.tlinea,x-lineas-del-docmto) > 0 THEN DO:
                /* La linea no debe haberse trabajado x el jefe de linea */
                IF LOOKUP(ttLineasAutorizadas.tlinea,x-lineas-trabajadas) = 0 THEN DO:
                    x-registro-valido = YES.
                    LEAVE valida-linea.
                END.
            END.
        END.
        IF x-registro-valido = NO THEN DO:
            RETURN ERROR.
        END.
    /*END.*/

    RETURN.
END.
*/

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "GN-DIVI"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "GN-DIVI"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carga-temporal B-table-Win 
PROCEDURE carga-temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/*
        x-registro-valido = NO.
        x-lineas-del-docmto = TRIM(ttccbcdocu.libre_c01).     /* Lineas del documento */
        x-lineas-trabajadas = TRIM(ttccbcdocu.libre_c02).     /* Lineas trabajadas x el jefe de linea */

        VALIDA-LINEA:
        FOR EACH ttLineasAutorizadas NO-LOCK:
            IF LOOKUP(ttLineasAutorizadas.tlinea,x-lineas-del-docmto) > 0 THEN DO:
                /* La linea no debe haberse trabajado x el jefe de linea */
                IF LOOKUP(ttLineasAutorizadas.tlinea,x-lineas-trabajadas) = 0 THEN DO:
                    x-registro-valido = YES.
                    LEAVE valida-linea.
                END.
            END.
        END.
        IF x-registro-valido = NO THEN DO:
            RETURN ERROR.
        END.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-busca B-table-Win 
PROCEDURE local-busca :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE OK-WAIT-STATE AS LOGICAL NO-UNDO.
  ASSIGN  input-var-1 = ""
          input-var-2 = ""
          input-var-3 = ""
          output-var-1 = ?
          OK-WAIT-STATE = SESSION:SET-WAIT-STATE("GENERAL").

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'busca':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  DO ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
    /*RUN PL/C-XXX.W("").*/
    IF OUTPUT-VAR-1 <> ? THEN DO:
         FIND {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} WHERE
              ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}) = OUTPUT-VAR-1
              NO-LOCK NO-ERROR.
         IF AVAIL {&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}} THEN DO:
            REPOSITION {&BROWSE-NAME}  TO ROWID OUTPUT-VAR-1.
         END.
    END.
  END.
  OK-WAIT-STATE = SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record B-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN valida.
  IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procesa-parametros B-table-Win 
PROCEDURE procesa-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    output-var-1 como ROWID
    output-var-2 como CHARACTER
    output-var-3 como CHARACTER.
    */
    CASE HANDLE-CAMPO:name:
        WHEN "" THEN.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recoge-parametros B-table-Win 
PROCEDURE recoge-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
    Variables a usar:
    input-var-1 como CHARACTER
    input-var-2 como CHARACTER
    input-var-3 como CHARACTER.
    */

    CASE HANDLE-CAMPO:name:
        WHEN "" THEN .
        /*
            ASSIGN
                input-para-1 = ""
                input-para-2 = ""
                input-para-3 = "".
         */      
    END CASE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refrescar B-table-Win 
PROCEDURE refrescar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

SESSION:SET-WAIT-STATE("GENERAL").                 

EMPTY TEMP-TABLE ttccbcdocu.

DEFINE VAR x-lineas-del-docmto AS CHAR.
DEFINE VAR x-lineas-trabajadas AS CHAR.
DEFINE VAR x-registro-valido AS LOG.

FOR EACH ccbcdocu WHERE INTEGRAL.ccbcdocu.CodCia = s-codcia AND
                        INTEGRAL.ccbcdocu.CodDoc = x-coddoc AND
                        INTEGRAL.ccbcdocu.tpofac = 'OTROS' AND
                        CAN-DO(x-estados,INTEGRAL.ccbcdocu.flgest) NO-LOCK:
    x-registro-valido = NO.
    x-lineas-del-docmto = TRIM(ccbcdocu.libre_c01).     /* Lineas del documento */
    x-lineas-trabajadas = TRIM(ccbcdocu.libre_c02).     /* Lineas trabajadas x el jefe de linea */

    VALIDA-LINEA:
    FOR EACH ttLineasAutorizadas NO-LOCK:
        IF LOOKUP(ttLineasAutorizadas.tlinea,x-lineas-del-docmto) > 0 THEN DO:
            /* La linea no debe haberse trabajado x el jefe de linea */
            IF LOOKUP(ttLineasAutorizadas.tlinea,x-lineas-trabajadas) = 0 THEN DO:
                x-registro-valido = YES.
                LEAVE valida-linea.
            END.
        END.
    END.
    IF x-registro-valido = YES THEN DO:
        CREATE ttccbcdocu.
        BUFFER-COPY ccbcdocu TO ttccbcdocu.
    END.
END.

/*{&OPEN-QUERY-br_table}*/
{&OPEN-QUERY-browse-2}

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "GN-DIVI"}
  {src/adm/template/snd-list.i "ttCcbCDocu"}
  {src/adm/template/snd-list.i "CcbCDocu"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  IF p-state = 'update-begin':U THEN DO:
     RUN valida-update.
     IF RETURN-VALUE = "ADM-ERROR" THEN RETURN.
  END.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida B-table-Win 
PROCEDURE valida :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE valida-update B-table-Win 
PROCEDURE valida-update :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fEstado B-table-Win 
FUNCTION fEstado RETURNS CHARACTER
  ( INPUT pEstado AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR x-retval AS CHAR.

    DEFINE VAR x-codigo-estados AS CHAR.
    DEFINE VAR x-descripcion-estados AS CHAR.

    x-codigo-estados = "T,D,P,R,G,A".
    x-descripcion-estados = "GENERADA,FALTAN APROBACIONES,APROBADO,RECHAZADO,N/C GENERADA,ANULADA".
                                      
    x-retval = "DESCONOCIDO(" + STRING(pEstado) + ")" NO-ERROR.

    IF LOOKUP(pEstado,x-codigo-estados) > 0 THEN DO:
        x-retval = ENTRY(LOOKUP(pEstado,x-codigo-estados),x-descripcion-estados).
    END.

    RETURN x-retval.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

