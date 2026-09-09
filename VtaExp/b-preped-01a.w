&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE B-CPEDI NO-UNDO LIKE FacCPedi
       INDEX Llave01 AS PRIMARY Libre_d01.
DEFINE SHARED TEMP-TABLE B-DPEDI NO-UNDO LIKE FacDPedi.
DEFINE BUFFER BCPEDI FOR FacCPedi.



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

/* Local Variable Definitions ---                                       */

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR lh_Handle AS HANDLE.

DEF VAR s-coddoc AS CHAR INIT 'COT' NO-UNDO.

DEF TEMP-TABLE T-CPEDI LIKE B-CPEDI.
DEF BUFFER BB-CPEDI FOR B-CPEDI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartBrowser
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES B-CPEDI

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table B-CPEDI.Libre_d01 B-CPEDI.NroPed ~
B-CPEDI.CodCli B-CPEDI.NomCli B-CPEDI.FchPed B-CPEDI.FchEnt B-CPEDI.ImpTot 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table 
&Scoped-define QUERY-STRING-br_table FOR EACH B-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-br_table OPEN QUERY br_table FOR EACH B-CPEDI WHERE ~{&KEY-PHRASE} NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-br_table B-CPEDI
&Scoped-define FIRST-TABLE-IN-QUERY-br_table B-CPEDI


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table 
&Scoped-Define DISPLAYED-OBJECTS f-Mensaje 

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


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE f-Mensaje AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY 1
     FONT 6 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR 
      B-CPEDI SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _STRUCTURED
  QUERY br_table NO-LOCK DISPLAY
      B-CPEDI.Libre_d01 COLUMN-LABEL "Orden" FORMAT ">>>9":U
      B-CPEDI.NroPed COLUMN-LABEL "Numero Cotizacion" FORMAT "X(9)":U
      B-CPEDI.CodCli COLUMN-LABEL "Cliente" FORMAT "x(11)":U WIDTH 13
      B-CPEDI.NomCli FORMAT "x(50)":U
      B-CPEDI.FchPed COLUMN-LABEL "Fecha Pedido" FORMAT "99/99/9999":U
      B-CPEDI.FchEnt FORMAT "99/99/9999":U
      B-CPEDI.ImpTot COLUMN-LABEL "Saldo Actual" FORMAT "->>,>>>,>>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 104 BY 6.69
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     f-Mensaje AT ROW 7.73 COL 1 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE  WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartBrowser
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: B-CPEDI T "SHARED" NO-UNDO INTEGRAL FacCPedi
      ADDITIONAL-FIELDS:
          INDEX Llave01 AS PRIMARY Libre_d01
      END-FIELDS.
      TABLE: B-DPEDI T "SHARED" NO-UNDO INTEGRAL FacDPedi
      TABLE: BCPEDI B "?" ? INTEGRAL FacCPedi
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
         HEIGHT             = 7.81
         WIDTH              = 113.43.
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
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN f-Mensaje IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _TblList          = "Temp-Tables.B-CPEDI"
     _Options          = "NO-LOCK KEY-PHRASE SORTBY-PHRASE"
     _FldNameList[1]   > Temp-Tables.B-CPEDI.Libre_d01
"B-CPEDI.Libre_d01" "Orden" ">>>9" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.B-CPEDI.NroPed
"B-CPEDI.NroPed" "Numero Cotizacion" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.B-CPEDI.CodCli
"B-CPEDI.CodCli" "Cliente" ? "character" ? ? ? ? ? ? no ? no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = Temp-Tables.B-CPEDI.NomCli
     _FldNameList[5]   > Temp-Tables.B-CPEDI.FchPed
"B-CPEDI.FchPed" "Fecha Pedido" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = Temp-Tables.B-CPEDI.FchEnt
     _FldNameList[7]   > Temp-Tables.B-CPEDI.ImpTot
"B-CPEDI.ImpTot" "Saldo Actual" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win 


/* ***************************  Main Block  *************************** */

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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bajar B-table-Win 
PROCEDURE Bajar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
FIND LAST BB-CPEDI.
IF iOrden = BB-CPEDI.Libre_d01 THEN RETURN.
RAW-TRANSFER B-CPEDI TO rRecord.
DELETE B-CPEDI.

FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden + 1.
B-CPEDI.Libre_d01 = iOrden.
CREATE B-CPEDI.
RAW-TRANSFER rRecord TO B-CPEDI.
B-CPEDI.Libre_d01 = iOrden + 1.

RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden + 1.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Borra-Prepedidos-Pendientes B-table-Win 
PROCEDURE Borra-Prepedidos-Pendientes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR iOrden AS INT INIT 0 NO-UNDO.    

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH Faccpedi WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddiv = s-coddiv
            AND Faccpedi.coddoc = 'PPD'
            AND Faccpedi.flgest = 'P'
            BY Faccpedi.nroped:
        /* extornamos cotizaciones */
        RUN gn/actualiza-cotizacion ( ROWID(FacCPedi) , -1 ).       /* Descarga COT */
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
        ASSIGN Faccpedi.flgest = 'A'.
        /* cargamos la cotizacion */
        FIND BCPEDI WHERE BCPEDI.codcia = s-codcia
            AND BCPEDI.coddoc = s-coddoc
            AND BCPEDI.nroped = Faccpedi.nroref
            NO-LOCK.
        f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Faccpedi.coddoc + ' ' + Faccpedi.nroped.
        iOrden = iOrden + 1.
        CREATE B-CPEDI.
        BUFFER-COPY BCPEDI TO B-CPEDI
            ASSIGN
                B-CPEDI.Libre_d01 = iOrden.
        FOR EACH Facdpedi OF BCPEDI NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
                FIRST Almmmatg OF Facdpedi NO-LOCK:
            CREATE B-DPEDI.
            BUFFER-COPY Facdpedi TO B-DPEDI.
            ASSIGN
                B-DPEDI.Libre_d01 = (Facdpedi.CanPed - Facdpedi.CanAte).
            IF  B-DPEDI.Libre_d01 <> B-DPEDI.CanPed THEN DO:
                ASSIGN
                    B-DPEDI.ImpDto = ROUND( B-DPEDI.PreUni * B-DPEDI.Libre_d01 * (B-DPEDI.Por_Dsctos[1] / 100),4 )
                    B-DPEDI.ImpLin = ROUND( B-DPEDI.PreUni * B-DPEDI.Libre_d01 , 2 ) - B-DPEDI.ImpDto.
                IF B-DPEDI.AftIsc 
                THEN B-DPEDI.ImpIsc = ROUND(B-DPEDI.PreBas * B-DPEDI.Libre_d01 * (Almmmatg.PorIsc / 100),4).
                IF B-DPEDI.AftIgv 
                THEN  B-DPEDI.ImpIgv = B-DPEDI.ImpLin - ROUND(B-DPEDI.ImpLin  / (1 + (BCPEDI.PorIgv / 100)),4).
            END.
        END.
    END.
    RELEASE Faccpedi.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Temporal B-table-Win 
PROCEDURE Carga-Temporal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pFchEnt AS DATE.

DEF VAR iOrden AS INT INIT 1 NO-UNDO.

FOR EACH B-CPEDI:
    DELETE B-CPEDI.
END.
FOR EACH B-DPEDI:
    DELETE B-DPEDI.
END.

/* Cargamos Pre-Pedidos pendientes */
RUN Borra-Prepedidos-Pendientes.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN.
FIND LAST B-CPEDI NO-LOCK NO-ERROR.
IF AVAILABLE B-CPEDI THEN iOrden = B-CPEDI.Libre_d01 + 1.

FOR EACH Faccpedi NO-LOCK WHERE Faccpedi.codcia = s-codcia
    AND Faccpedi.coddiv = s-coddiv
    AND Faccpedi.coddoc = s-coddoc 
    AND Faccpedi.flgest = 'P'
    AND Faccpedi.fchent <= pFchEnt:
    FIND FIRST B-CPEDI WHERE B-CPEDI.NroPed = Faccpedi.NroPed NO-LOCK NO-ERROR.
    IF AVAILABLE B-CPEDI THEN NEXT.
    f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Procesando ' + Faccpedi.coddoc + ' ' + Faccpedi.nroped.
    CREATE B-CPEDI.
    BUFFER-COPY Faccpedi TO B-CPEDI
        ASSIGN
            B-CPEDI.Libre_d01 = iOrden.
    iOrden = iOrden + 1.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK WHERE (Facdpedi.CanPed - Facdpedi.CanAte) > 0,
            FIRST Almmmatg OF Facdpedi NO-LOCK:
        CREATE B-DPEDI.
        BUFFER-COPY Facdpedi TO B-DPEDI.
        ASSIGN
            B-DPEDI.Libre_d01 = (Facdpedi.CanPed - Facdpedi.CanAte).
        IF  B-DPEDI.Libre_d01 <> B-DPEDI.CanPed THEN DO:
            ASSIGN
                B-DPEDI.ImpDto = ROUND( B-DPEDI.PreUni * B-DPEDI.Libre_d01 * (B-DPEDI.Por_Dsctos[1] / 100),4 )
                B-DPEDI.ImpLin = ROUND( B-DPEDI.PreUni * B-DPEDI.Libre_d01 , 2 ) - B-DPEDI.ImpDto.
            IF B-DPEDI.AftIsc 
            THEN B-DPEDI.ImpIsc = ROUND(B-DPEDI.PreBas * B-DPEDI.Libre_d01 * (Almmmatg.PorIsc / 100),4).
            IF B-DPEDI.AftIgv 
            THEN  B-DPEDI.ImpIgv = B-DPEDI.ImpLin - ROUND(B-DPEDI.ImpLin  / (1 + (Faccpedi.PorIgv / 100)),4).
        END.
    END.
END.
/* TOTALES */
FOR EACH B-CPEDI:
    B-CPEDI.ImpTot = 0.
    FOR EACH B-DPEDI WHERE B-DPEDI.codcia = B-CPEDI.codcia
        AND B-DPEDI.coddoc = B-CPEDI.coddoc
        AND B-DPEDI.nroped = B-CPEDI.nroped:
        B-CPEDI.ImpTot = B-CPEDI.ImpTot + B-DPEDI.ImpLin.
    END.
END.

f-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

END PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Eliminar B-table-Win 
PROCEDURE Eliminar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
DELETE B-CPEDI.

xOrden = 1.
FOR EACH B-CPEDI:
    B-CPEDI.Libre_d01 = xOrden.
    xOrden = xOrden + 1.
END.
RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN FIND PREV B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record B-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  FOR EACH B-DPEDI WHERE B-DPEDI.codcia = B-CPEDI.codcia
        AND B-DPEDI.coddoc = B-CPEDI.coddoc
        AND B-DPEDI.nroped = B-CPEDI.nroped:
      DELETE B-DPEDI.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Poner-Primero B-table-Win 
PROCEDURE Poner-Primero :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
IF iOrden = 1 THEN RETURN.
RAW-TRANSFER B-CPEDI TO rRecord.
DELETE B-CPEDI.

FOR EACH T-CPEDI:
    DELETE T-CPEDI.
END.

xOrden = 2.
FOR EACH B-CPEDI BY B-CPEDI.Libre_d01:
    CREATE T-CPEDI.
    BUFFER-COPY B-CPEDI TO T-CPEDI
        ASSIGN T-CPEDI.Libre_d01 = xOrden.
    xOrden = xOrden + 1.
    DELETE B-CPEDI.
END.

CREATE T-CPEDI.
RAW-TRANSFER rRecord TO T-CPEDI.
ASSIGN T-CPEDI.Libre_d01 = 1.

FOR EACH T-CPEDI:
    CREATE B-CPEDI.
    BUFFER-COPY T-CPEDI TO B-CPEDI.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = 1.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Poner-Ultimo B-table-Win 
PROCEDURE Poner-Ultimo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
FIND LAST BB-CPEDI.
IF iOrden = BB-CPEDI.Libre_d01 THEN RETURN.
RAW-TRANSFER B-CPEDI TO rRecord.
DELETE B-CPEDI.

FOR EACH T-CPEDI:
    DELETE T-CPEDI.
END.

xOrden = 1.
FOR EACH B-CPEDI BY B-CPEDI.Libre_d01:
    CREATE T-CPEDI.
    BUFFER-COPY B-CPEDI TO T-CPEDI
        ASSIGN T-CPEDI.Libre_d01 = xOrden.
    xOrden = xOrden + 1.
    DELETE B-CPEDI.
END.

CREATE T-CPEDI.
RAW-TRANSFER rRecord TO T-CPEDI.
ASSIGN T-CPEDI.Libre_d01 = xOrden.

FOR EACH T-CPEDI:
    CREATE B-CPEDI.
    BUFFER-COPY T-CPEDI TO B-CPEDI.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = xOrden.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').

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
  {src/adm/template/snd-list.i "B-CPEDI"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Subir B-table-Win 
PROCEDURE Subir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR iOrden AS INT NO-UNDO.
DEF VAR xOrden AS INT NO-UNDO.
DEF VAR rRecord AS RAW NO-UNDO.

IF NOT AVAILABLE B-CPEDI THEN RETURN.

iOrden = B-CPEDI.Libre_d01.
IF iOrden = 1 THEN RETURN.
RAW-TRANSFER B-CPEDI TO rRecord.
DELETE B-CPEDI.

FOR EACH T-CPEDI:
    DELETE T-CPEDI.
END.

xOrden = 1.
FOR EACH B-CPEDI BY B-CPEDI.Libre_d01:
    IF B-CPEDI.Libre_d01 = iOrden - 1 THEN DO:
        CREATE T-CPEDI.
        RAW-TRANSFER rRecord TO T-CPEDI.
        T-CPEDI.Libre_d01 = iOrden - 1.
        xOrden = xOrden + 1.
    END.
    CREATE T-CPEDI.
    BUFFER-COPY B-CPEDI TO T-CPEDI
        ASSIGN T-CPEDI.Libre_d01 = xOrden.
    xOrden = xOrden + 1.
    DELETE B-CPEDI.
END.

FOR EACH T-CPEDI:
    CREATE B-CPEDI.
    BUFFER-COPY T-CPEDI TO B-CPEDI.
END.

RUN dispatch IN THIS-PROCEDURE ('open-query').
FIND B-CPEDI WHERE B-CPEDI.Libre_d01 = iOrden - 1.
REPOSITION {&BROWSE-NAME} TO ROWID ROWID(B-CPEDI).
RUN dispatch IN THIS-PROCEDURE ('row-changed').


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

